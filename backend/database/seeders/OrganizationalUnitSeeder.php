<?php

namespace Database\Seeders;

use App\Models\OrganizationalUnit;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class OrganizationalUnitSeeder extends Seeder
{
    private array $organigrama = [
        [
            'name' => 'Despacho Ministerial de Cultura',
            'code' => 'DM',
            'children' => [
                [
                    'name' => 'Dirección General Ejecutiva',
                    'code' => 'DGE',
                    'children' => [
                        ['name' => 'Oficial de Cumplimiento', 'code' => 'OC'],
                        ['name' => 'Dirección General de Multiculturalidad', 'code' => 'DGMC'],
                        ['name' => 'Dirección General de Proyectos de Inversión e Infraestructura', 'code' => 'DGPII'],
                        ['name' => 'Dirección General de Planificación y Desarrollo Institucional', 'code' => 'DGPDI'],
                        ['name' => 'Dirección General de Informática y Sistemas', 'code' => 'DGIS'],
                        ['name' => 'Dirección General Ambiental', 'code' => 'DGAM'],
                        ['name' => 'Dirección General de Relaciones Internacionales y Cooperación', 'code' => 'DGRIC'],
                        ['name' => 'Dirección General Financiera Institucional', 'code' => 'DGFI'],
                        [
                            'name' => 'Dirección General de Asuntos Jurídicos',
                            'code' => 'DGAJ',
                            'children' => [
                                ['name' => 'Unidad de Género', 'code' => 'UG'],
                            ],
                        ],
                        ['name' => 'Dirección General de Auditoría Interna', 'code' => 'DGAI'],
                        ['name' => 'Dirección General de Comunicaciones Institucionales', 'code' => 'DGCI'],
                        [
                            'name' => 'Dirección General de Administración',
                            'code' => 'DGAD',
                            'children' => [
                                ['name' => 'Unidad de Talento Humano', 'code' => 'UTH'],
                                ['name' => 'Unidad de Activo Fijo', 'code' => 'UAF'],
                                ['name' => 'Unidad de Compras Públicas', 'code' => 'UCP'],
                                ['name' => 'Unidad de Logística', 'code' => 'ULOG'],
                                ['name' => 'Unidad de Acceso a la Información Pública', 'code' => 'UAIP'],
                                ['name' => 'Unidad de Gestión Documental y Archivos', 'code' => 'UGDA'],
                            ],
                        ],
                    ],
                ],
                [
                    'name' => 'Biblioteca Nacional de El Salvador',
                    'code' => 'BINAES',
                    'children' => [
                        ['name' => 'Bibliotecas', 'code' => 'BIB'],
                        ['name' => 'Editorial El Salvador', 'code' => 'EES'],
                        ['name' => 'Archivo General de la Nación', 'code' => 'AGN'],
                    ],
                ],
                [
                    'name' => 'Dirección Nacional de Artes',
                    'code' => 'DNA',
                    'children' => [
                        [
                            'name' => 'Dirección de Teatros',
                            'code' => 'DT',
                            'children' => [
                                ['name' => 'Teatro Nacional de San Salvador', 'code' => 'TNSS'],
                                ['name' => 'Teatro Nacional de Santa Ana', 'code' => 'TNSA'],
                                ['name' => 'Teatro Nacional Francisco Gavidia de San Miguel', 'code' => 'TNFG'],
                                ['name' => 'Teatro Presidente', 'code' => 'TP'],
                                ['name' => 'Programación Cultural', 'code' => 'PC'],
                            ],
                        ],
                        ['name' => 'Ballet Nacional de El Salvador', 'code' => 'BNES'],
                        ['name' => 'Ballet Folklórico Nacional', 'code' => 'BFN'],
                        ['name' => 'Compañía Nacional de Danza', 'code' => 'CND'],
                        ['name' => 'Orquesta Sinfónica de El Salvador', 'code' => 'OSES'],
                    ],
                ],
                [
                    'name' => 'Dirección Nacional de Formación en Artes',
                    'code' => 'DNFA',
                    'children' => [
                        ['name' => 'Escuela Nacional de Música', 'code' => 'ENM'],
                        ['name' => 'Coro El Salvador', 'code' => 'CES'],
                        ['name' => 'Banda El Salvador', 'code' => 'BES'],
                        ['name' => 'Escuela Nacional de Danza Morena Celarié', 'code' => 'ENDMC'],
                        ['name' => 'Centro Nacional de Artes (CENAR)', 'code' => 'CENAR'],
                        ['name' => 'Centros de Formación en Artes', 'code' => 'CFA'],
                    ],
                ],
                [
                    'name' => 'Dirección Nacional de Espacios Culturales',
                    'code' => 'DNEC',
                    'children' => [
                        [
                            'name' => 'Dirección de Museos y Salas de Exposiciones',
                            'code' => 'DMSE',
                            'children' => [
                                ['name' => 'Museo Nacional de Antropología Dr. David J. Guzmán', 'code' => 'MUNA'],
                                ['name' => 'Museo de Historia Natural de El Salvador', 'code' => 'MUHNES'],
                                ['name' => 'Museo Regional de Occidente', 'code' => 'MRO'],
                                ['name' => 'Museo Regional de Oriente', 'code' => 'MRTE'],
                                ['name' => 'Centro de Memorias El Mozote', 'code' => 'CMEM'],
                                ['name' => 'Salas de Exposiciones', 'code' => 'SE'],
                            ],
                        ],
                        [
                            'name' => 'Dirección de Centros Culturales',
                            'code' => 'DCC',
                            'children' => [
                                ['name' => 'Centros Culturales', 'code' => 'CC'],
                                ['name' => 'Palacio Nacional', 'code' => 'PN'],
                                ['name' => 'Ex Casa Presidencial', 'code' => 'ECP'],
                            ],
                        ],
                    ],
                ],
                [
                    'name' => 'Dirección Nacional de Patrimonio Cultural',
                    'code' => 'DNPC',
                    'children' => [
                        [
                            'name' => 'Dirección de Antropología Cultural',
                            'code' => 'DAC',
                            'children' => [
                                ['name' => 'Unidad de Investigaciones Antropológicas', 'code' => 'UIAN'],
                            ],
                        ],
                        ['name' => 'Dirección de Conservación de Bienes Culturales Muebles', 'code' => 'DCBCM'],
                        ['name' => 'Dirección de Registro de Bienes Culturales', 'code' => 'DRBC'],
                        [
                            'name' => 'Dirección de Arqueología',
                            'code' => 'DARQ',
                            'children' => [
                                ['name' => 'Unidad de Investigación Arqueológica', 'code' => 'UIA'],
                                ['name' => 'Unidad de Parques y Sitios Arqueológicos', 'code' => 'UPSA'],
                            ],
                        ],
                        [
                            'name' => 'Dirección de Asistencia Técnica en Patrimonio Edificado y Contexto Urbano',
                            'code' => 'DATPECU',
                            'children' => [
                                ['name' => 'Unidad de Inventarios de Bienes Culturales Inmuebles', 'code' => 'UIBCI'],
                            ],
                        ],
                    ],
                ],
            ],
        ],
    ];

    public function run(): void
    {
        DB::transaction(function () {
            foreach ($this->organigrama as $node) {
                $this->createRecursive($node, null);
            }
        });
    }

    /**
     * Crea (o actualiza, si ya existe por 'code') un departamento y, de forma
     * recursiva, todos sus hijos — enlazándolos automáticamente con el
     * parent_id del nodo que se acaba de crear.
     */
    private function createRecursive(array $node, ?int $parentId): void
    {
        $department = OrganizationalUnit::updateOrCreate(
            ['code' => $node['code']],
            [
                'name' => $node['name'],
                'description' => $node['description'] ?? null,
                'status' => true,
                'parent_id' => $parentId,
            ]
        );

        foreach ($node['children'] ?? [] as $child) {
            $this->createRecursive($child, $department->id);
        }
    }
}
