<?php

namespace App\Http\Controllers;

use Inertia\Inertia;
use Inertia\Response;
use Illuminate\Http\Request;

use App\Models\WiFiMaxx\UserAccess;

class ReportsController extends Controller
{
    public function index(Request $request): Response
    {
        return Inertia::render('Reports/Index');
    }

    public function byDay(Request $request): Response
    {
        $start = $request->input('start_date', '2025-01-01');
        $end = $request->input('end_date', '2025-05-01');

        return Inertia::render('Reports/AnalysisByDay', [
            'filters'=>(object)[
                'start_date'=>$start,
                'end_date'=>$end
            ]
        ]);
    }

    public function tempEvolution(Request $request): Response
    {
        $start = $request->input('start_date', '2025-01-01');
        $end = $request->input('end_date', '2025-05-01');

        return Inertia::render('Reports/TemporalEvolution', [
            'avgMonthUsers' => UserAccess::getAvgMonthUsers(),
            'filters'=>(object)[
                'start_date'=>$start,
                'end_date'=>$end
            ]
        ]);
    }
}
