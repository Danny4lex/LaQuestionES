<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Type;

class TypeSeeder extends Seeder
{
    public function run(): void
    {
        $types = [
            [
                'name'        => 'Pública',
                'description' => 'Acceso por enlace/QR libre'
            ],
            [
                'name'        => 'Privada',
                'description' => 'Solo para invitados en grupos específicos'
            ]
        ];

        foreach ($types as $type) {
            Type::updateOrInsert(['name' => $type['name']], $type);
        }
    }
}
