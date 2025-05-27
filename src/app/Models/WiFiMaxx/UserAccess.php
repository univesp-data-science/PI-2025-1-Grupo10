<?php

namespace App\Models\WiFiMaxx;

use Illuminate\Support\Facades\DB;
use Illuminate\Database\Eloquent\Model;

use Illuminate\Support\Carbon;

class UserAccess extends Model
{
    protected $table    = 'portal_profile';
    protected $guarded  = ['id'];

    public static function getResumoPorHora($dataInicio = null, $dataFim = null){

        $inicio = $dataInicio ?? Carbon::now()->subDays(7)->startOfDay();
        $fim = $dataFim ?? Carbon::now()->endOfDay();

        return DB::table('wifimaxx_total_access_by_hour')
            ->selectRaw('HOUR(`computed_hour`) as hour')
            ->selectRaw('SUM(users) as total_users')
            ->selectRaw('SUM(acctsessiontime) as total_session_time')
            ->selectRaw('SUM(acctinputoctets) as total_input_octets')
            ->selectRaw('SUM(acctoutputoctets) as total_output_octets')
            ->whereBetween('computed_hour', [$dataInicio, $dataFim])
            ->groupBy('hour')
            ->orderBy('hour')
            ->get();

    }

    public static function getResumoPorDiaDaSemana($dataInicio = null, $dataFim = null){

        $inicio = $dataInicio ?? Carbon::now()->subDays(7)->startOfDay();
        $fim = $dataFim ?? Carbon::now()->endOfDay();

        return DB::table('wifimaxx_total_access_by_day')
            ->selectRaw("WEEKDAY(computed_day) as week_day") // 0 = segunda, 6 = domingo
            ->selectRaw("SUM(users) as total_users")
            ->selectRaw("SUM(acctsessiontime) as total_session_time")
            ->selectRaw("SUM(acctinputoctets) as total_input_octets")
            ->selectRaw("SUM(acctoutputoctets) as total_output_octets")
            ->whereBetween('computed_day', [$inicio, $fim])
            ->groupBy('week_day')
            ->orderBy('week_day')
            ->get();
            /*
            ->map(function ($item) {
                $dias = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
                $item->label = $dias[$item->week_day] ?? 'N/D';
                return $item;
            });
            */
    }

    public static function getAverages($startDate = null, $endDate = null)
    {
        $start = $startDate ?? Carbon::now()->subDays(7)->startOfDay();
        $end = $endDate ?? Carbon::now()->endOfDay();

        return DB::table('wifimaxx_total_access_by_day')
            ->selectRaw('ROUND(AVG(users)) as avg_users')
            ->selectRaw('ROUND(AVG(acctsessiontime)) as avg_session_time')
            ->selectRaw('ROUND(AVG(acctinputoctets)) as avg_input_octets')
            ->selectRaw('ROUND(AVG(acctoutputoctets)) as avg_output_octets')
            ->whereBetween('computed_day', [$start, $end])
            ->first();
    }

    public static function getPeaks($startDate = null, $endDate = null)
    {
        $start = $startDate ?? Carbon::now()->subDays(7)->startOfDay();
        $end = $endDate ?? Carbon::now()->endOfDay();

        return DB::table('wifimaxx_total_access_by_day')
            ->selectRaw('MAX(users) as peak_users')
            ->selectRaw('MAX(acctsessiontime) as peak_session_time')
            ->selectRaw('MAX(acctinputoctets) as peak_input_octets')
            ->selectRaw('MAX(acctoutputoctets) as peak_output_octets')
            ->whereBetween('computed_day', [$start, $end])
            ->first();
    }

    public static function getAvgMonthUsers($startDate = null, $endDate = null)
    {
        $start = $startDate ?? Carbon::now()->subDays(7)->startOfDay();
        $end = $endDate ?? Carbon::now()->endOfDay();

        return DB::table('wifimaxx_total_access_by_month')
            ->select()
            //->whereBetween('computed_month', [$start, $end])
            ->get();
    }

}
