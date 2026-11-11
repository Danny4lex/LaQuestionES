<?php

use App\Http\Controllers\DepartmentController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/status', fn () => response()->json(["message" => "Active"]));

// Route::resource('/api/department', DepartmentController::class);
// TEMPORAL — solo para diagnosticar el PDF. Borrar después.
Route::get('/debug-pdf', function () {
    return view('reports.layout', ['logo' => null]);
});