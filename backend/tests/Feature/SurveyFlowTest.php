namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use App\Models\Survey;
use Illuminate\Foundation\Testing\RefreshDatabase;

class SurveyFlowTest extends TestCase
{
    /** @test */
    public function flujo_completo_de_encuesta_funciona_correctamente()
    {
        $user = User::factory()->create();

        // 1. Probar carga del listado
        $response = $this->actingAs($user)->getJson('/api/surveys');
        $response->assertStatus(200);

        // 2. Probar detalle de una encuesta existente
        $survey = Survey::first();
        if ($survey) {
            $responseDetail = $this->actingAs($user)->getJson("/api/surveys/{$survey->id}");
            $responseDetail->assertStatus(200)
                           ->assertJsonStructure(['id', 'title', 'sections']);
        }
    }
}