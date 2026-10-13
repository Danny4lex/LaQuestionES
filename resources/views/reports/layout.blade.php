<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <title>@yield('title')</title>
    <style>
        /* Paleta del proyecto (frontend/src/assets/styles/variables.scss) */
        @page { margin: 118px 34px 62px 34px; }
        body { font-family: 'DejaVu Sans', sans-serif; font-size: 10px; color: #374957; }

        .header { position: fixed; top: -118px; left: -34px; right: -34px; height: 96px; background: #2D52A7; }
        .header table { width: 100%; border-collapse: collapse; }
        .header td { vertical-align: middle; color: #ffffff; }
        .header .logo-cell { width: 84px; padding: 12px 0 0 34px; }
        .header .logo { width: 66px; height: 66px; }
        .header .kicker { font-size: 8px; letter-spacing: 1px; text-transform: uppercase; opacity: .85; padding-top: 12px; }
        .header .title { font-size: 16px; font-weight: bold; line-height: 1.25; padding-top: 3px; }
        .header .subtitle { font-size: 9px; padding-top: 3px; }
        .header .meta-cell { width: 150px; padding: 12px 34px 0 0; text-align: right; font-size: 8px; }
        .accent { position: fixed; top: -22px; left: -34px; right: -34px; height: 4px; background: #4880FF; }

        .footer { position: fixed; bottom: -46px; left: 0; right: 0; height: 30px; border-top: 1px solid #D2D9DD; font-size: 8px; color: #374957; }
        .footer table { width: 100%; border-collapse: collapse; margin-top: 6px; }
        .footer .right { text-align: right; }
        .pagenum:before { content: counter(page); }

        h2 { font-size: 12px; color: #2D52A7; margin: 18px 0 8px 0; padding-bottom: 4px; border-bottom: 2px solid #4880FF; }
        p { margin: 0 0 6px 0; }
        .muted { color: #6b7c8a; }

        /* Tarjetas de indicadores */
        table.cards { width: 100%; border-collapse: separate; border-spacing: 8px 0; margin: 0 -8px; }
        table.cards td { background: #F4F6FD; border: 1px solid #E3EBF5; border-radius: 6px; padding: 10px 8px; text-align: center; width: 25%; }
        .card-value { font-size: 20px; font-weight: bold; color: #063456; }
        .card-label { font-size: 8px; color: #374957; margin-top: 3px; }

        /* Datos generales */
        table.info { width: 100%; border-collapse: collapse; }
        table.info td { padding: 4px 6px; border-bottom: 1px solid #E3EBF5; }
        table.info td.k { width: 22%; color: #6b7c8a; }
        table.info td.v { width: 28%; color: #313845; font-weight: bold; }

        /* Tablas de datos */
        table.data { width: 100%; border-collapse: collapse; }
        table.data th { background: #2D52A7; color: #ffffff; text-align: left; padding: 6px 7px; font-size: 9px; }
        table.data td { padding: 5px 7px; border-bottom: 1px solid #E3EBF5; vertical-align: top; }
        table.data tr.alt td { background: #F9FBFE; }
        .num { text-align: right; }

        /* Pregunta */
        .question { border: 1px solid #E3EBF5; border-left: 3px solid #4880FF; border-radius: 4px; padding: 8px 10px; margin-bottom: 8px; page-break-inside: avoid; }
        .q-head { font-size: 10px; font-weight: bold; color: #313845; }
        .q-num { color: #4880FF; }
        .q-meta { font-size: 8px; color: #6b7c8a; margin: 2px 0 6px 0; }

        /* Barras */
        table.bars { width: 100%; border-collapse: collapse; }
        table.bars td { padding: 2px 0; vertical-align: middle; }
        td.bar-label { width: 34%; font-size: 9px; padding-right: 8px; }
        td.bar-track { width: 46%; }
        .track { background: #E8F0F8; height: 9px; width: 210px; border-radius: 3px; }
        .fill { background: #4880FF; height: 9px; border-radius: 3px; }
        td.bar-value { width: 20%; font-size: 9px; text-align: right; color: #313845; }

        .avg { font-size: 15px; font-weight: bold; color: #063456; }
        .quote { background: #F4F6FD; border-left: 2px solid #ACD7FF; padding: 4px 7px; margin-bottom: 3px; font-size: 9px; }

        /* Estados (badges) */
        .badge { padding: 2px 6px; border-radius: 4px; font-size: 8px; font-weight: bold; color: #313845; background: #D9D9D9; }
        .badge-published { background: #9EF18D; }
        .badge-scheduled { background: #F1B550; }
        .badge-closed { background: #E42716; color: #ffffff; }
        .badge-draft { background: #D9D9D9; }
        .note { background: #FFF7E6; border: 1px solid #F1B550; border-radius: 4px; padding: 6px 8px; font-size: 9px; margin-top: 6px; }
    </style>
</head>
<body>
    <div class="accent"></div>
    <div class="header">
        <table>
            <tr>
                <td class="logo-cell">
                    @if (!empty($logo))
                        <img class="logo" src="{{ $logo }}" alt="">
                    @endif
                </td>
                <td>
                    <div class="kicker">Ministerio de Cultura · Sistema de Gestión de Encuestas</div>
                    <div class="title">@yield('heading')</div>
                    <div class="subtitle">@yield('subheading')</div>
                </td>
                <td class="meta-cell">
                    Generado el<br>
                    <strong>{{ now()->format('d/m/Y H:i') }}</strong>
                </td>
            </tr>
        </table>
    </div>

    <div class="footer">
        <table>
            <tr>
                <td>Ministerio de Cultura — Sistema de Gestión de Encuestas e Indicadores Institucionales</td>
                <td class="right">Página <span class="pagenum"></span></td>
            </tr>
        </table>
    </div>

    @yield('content')
</body>
</html>
