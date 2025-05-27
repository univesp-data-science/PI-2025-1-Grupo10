<?php

namespace App\Http\Controllers;

use Inertia\Inertia;
use Inertia\Response;
use Illuminate\Http\Request;

use App\Models\WiFiMaxx\UserAccess;

class DashboardController extends Controller
{
    public function index(Request $request): Response
    {

        $start = $request->input('start_date', '2025-01-01 00:00:00');
        $end = $request->input('end_date', '2025-05-01 23:59:59');

        return Inertia::render('Dashboard/Index', [
            'accessByHour' => UserAccess::getResumoPorHora($start,$end),
            'accessByWeek' => UserAccess::getResumoPorDiaDaSemana($start,$end),
            'averages' => UserAccess::getAverages($start, $end),
            'peaks' => UserAccess::getPeaks($start, $end),
            'filters'=>(object)[
                'start_date'=>$start,
                'end_date'=>$end
            ]
        ]);

    }
}
