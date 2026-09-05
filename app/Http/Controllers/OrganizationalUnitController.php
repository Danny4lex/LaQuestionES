<?php

namespace App\Http\Controllers;

use App\Models\OrganizationalUnit;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Cache;

class OrganizationalUnitController extends Controller
{
    private const CACHE_KEY_LIST = 'catalog_organizational_units';
    private const CACHE_KEY_TREE = 'catalog_organizational_units_tree';
    private const CACHE_TTL = 86400; // 24 horas

    public function index(): JsonResponse
    {
        $organizationalUnits = Cache::remember(self::CACHE_KEY_LIST, self::CACHE_TTL, function () {
            return OrganizationalUnit::where('status', true)
                ->select(['id', 'name', 'code', 'description', 'parent_id', 'status'])
                ->orderBy('name')
                ->get();
        });

        return response()->json($organizationalUnits, 200);
    }

    public function tree(): JsonResponse
    {
        $cleanTree = Cache::remember(self::CACHE_KEY_TREE, self::CACHE_TTL, function () {
            $units = OrganizationalUnit::where('status', true)
                ->select(['id', 'name', 'code', 'description', 'parent_id', 'status'])
                ->orderBy('name')
                ->get();

            return $this->buildTree($units->toArray());
        });

        return response()->json($cleanTree, 200);
    }

    private function buildTree(array $nodes): array
    {
        $tree = [];
        $lookup = [];

        foreach ($nodes as $node) {
            $node['children'] = [];
            $lookup[$node['id']] = $node;
        }

        foreach ($lookup as $id => &$node) {
            if ($node['parent_id'] && isset($lookup[$node['parent_id']])) {
                $lookup[$node['parent_id']]['children'][] = &$node;
            } else {
                $tree[] = &$node;
            }
        }
        unset($node);

        return $tree;
    }

    private function clearCache(): void
    {
        Cache::forget(self::CACHE_KEY_LIST);
        Cache::forget(self::CACHE_KEY_TREE);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'code' => 'required|string|max:50|unique:organizational_units,code',
            'parent_id' => 'nullable|exists:organizational_units,id',
        ]);

        $organizationalUnit = OrganizationalUnit::create($validated);
        $this->clearCache();

        return response()->json($organizationalUnit, 201);
    }

    public function show(OrganizationalUnit $organizationalUnit): JsonResponse
    {
        return response()->json($organizationalUnit->load('parent'), 200);
    }

    public function update(Request $request, OrganizationalUnit $organizationalUnit): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'code' => 'sometimes|required|string|max:50|unique:organizational_units,code,' . $organizationalUnit->id,
            'parent_id' => 'nullable|exists:organizational_units,id|not_in:' . $organizationalUnit->id,
            'status' => 'sometimes|required|boolean',
        ]);

        $organizationalUnit->update($validated);
        $this->clearCache();

        return response()->json($organizationalUnit, 200);
    }

    public function destroy(OrganizationalUnit $organizationalUnit): JsonResponse
    {
        if ($organizationalUnit->children()->where('status', true)->exists()) {
            return response()->json([
                'message' => 'No se puede eliminar un departamento que tiene dependencias asignadas.'
            ], 422);
        }

        $organizationalUnit->delete();
        $this->clearCache();

        return response()->json(['message' => 'Unidad organizativa eliminada correctamente.'], 200);
    }
}