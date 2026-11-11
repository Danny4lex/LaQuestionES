<?php

namespace App\Console;

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    /**
     * Define the application's command schedule.
     */
    protected function schedule(Schedule $schedule): void
    {
        // Automatización de vigencia (ver App\Console\Commands\
        // ApplySurveyVigencia): antes esto estaba vacío y start_date/
        // end_date eran solo datos informativos que nadie aplicaba.
        // Corre cada hora porque una encuesta puede tener que publicarse
        // el mismo día a una hora específica; diario dejaría hasta 24h
        // de retraso.
        $schedule->command('surveys:apply-vigencia')->everyMinute();
    }

    /**
     * Register the commands for the application.
     */
    protected function commands(): void
    {
        $this->load(__DIR__.'/Commands');

        require base_path('routes/console.php');
    }
}
