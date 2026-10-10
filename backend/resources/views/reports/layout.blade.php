<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <title>@yield('title')</title>
    <style>
        /* =========================================================
           FUENTE — Poppins con fallback a DejaVu Sans
           ========================================================= */
           @font-face {
                font-family: 'Poppins';
                font-style: normal;
                font-weight: 300;
                src: url('{{ storage_path("fonts/Poppins-Light.ttf") }}') format('truetype');
            }
            @font-face {
                font-family: 'Poppins';
                font-style: normal;
                font-weight: 400;
                src: url('{{ storage_path("fonts/Poppins-Regular.ttf") }}') format('truetype');
            }
            @font-face {
                font-family: 'Poppins';
                font-style: normal;
                font-weight: 500;
                src: url('{{ storage_path("fonts/Poppins-Medium.ttf") }}') format('truetype');
            }
            @font-face {
                font-family: 'Poppins';
                font-style: normal;
                font-weight: 600;
                src: url('{{ storage_path("fonts/Poppins-SemiBold.ttf") }}') format('truetype');
            }
            @font-face {
                font-family: 'Poppins';
                font-style: normal;
                font-weight: 700;
                src: url('{{ storage_path("fonts/Poppins-Bold.ttf") }}') format('truetype');
            }

        /* =========================================================
           FORZAR POPPINS EN ABSOLUTAMENTE TODO
           ========================================================= */
        *,
        *::before,
        *::after {
            font-family: 'Poppins', 'DejaVu Sans', sans-serif !important;
        }

        html, body, div, span, p, h1, h2, h3, h4, h5, h6,
        table, thead, tbody, tr, td, th, strong, em, small, b {
            font-family: 'Poppins', 'DejaVu Sans', sans-serif !important;
        }

        /* =========================================================
           PAGE — margin-top = altura del header + margen de solape
           Header = 155px → margin-top = 177px (155 + 22)
           ========================================================= */
        @page { margin: 177px 34px 62px 34px; }

        body {
            font-family: 'Poppins', 'DejaVu Sans', sans-serif !important;
            font-size: 10px;
            color: #374957;
            line-height: 1.45;
        }

        /* =========================================================
           HEADER AZUL SÓLIDO — 155px de alto
           ========================================================= */
        .header {
            position: fixed;
            top: -177px; left: -34px; right: -34px;
            height: 155px;
            background: #063456;
        }

        .header table {
            position: relative;
            z-index: 1;
            width: 100%;
            border-collapse: collapse;
        }
        .header td { vertical-align: middle; color: #ffffff; }
        .header .logo-cell {
            width: 84px;
            padding: 22px 0 0 34px;
        }
        .header .logo { width: 66px; height: 66px; }
        .header .kicker {
            font-size: 8px;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            opacity: .80;
            font-weight: 600;
            padding-top: 22px;
        }
        .header .title {
                font-size: 20px;
                font-weight: 700;
                line-height: 0.8;
                padding-top: 5px;
                padding-bottom: 2px;
            }
        .header .subtitle {
            font-size: 10px;
            font-weight: 300;
            opacity: .90;
            padding-top: 4px;
            padding-bottom: 4px;
        }
        .header .meta-cell {
            width: 150px;
            padding: 22px 34px 0 0;
            text-align: right;
            font-size: 8px;
            opacity: .85;
        }

        /* Línea de acento superior */
        .accent {
            position: fixed;
            top: -22px; left: -34px; right: -34px;
            height: 4px;
            background: #4880FF;
        }

        /* =========================================================
           FOOTER
           ========================================================= */
        .footer {
            position: fixed;
            bottom: -46px; left: 0; right: 0;
            height: 30px;
            border-top: 1px solid #D2D9DD;
            font-size: 8px;
            color: #374957;
        }
        .footer table { width: 100%; border-collapse: collapse; margin-top: 6px; }
        .footer .right { text-align: right; }
        .pagenum:before { content: counter(page); }

        /* =========================================================
           TIPOGRAFÍA DE SECCIÓN
           ========================================================= */
        h2 {
            font-size: 12px;
            font-weight: 600;
            color: #2D52A7;
            margin: 18px 0 8px 0;
            padding: 0 0 6px 10px;
            border-left: 3px solid #4880FF;
            border-bottom: 1px solid #E3EBF5;
            line-height: 1.2;
        }
        p { margin: 0 0 6px 0; }
        .muted { color: #6b7c8a; font-weight: 300; }

        /* =========================================================
           TARJETAS KPI
           ========================================================= */
        table.cards {
            width: 100%;
            border-collapse: separate;
            border-spacing: 8px 0;
            margin: 0 -8px;
        }
        table.cards td {
            background: #ffffff;
            border: 1px solid #E3EBF5;
            border-top: 3px solid #4880FF;
            border-radius: 6px;
            padding: 12px 10px;
            text-align: center;
            width: 25%;
        }

        table.cards td,
        table.cards td div,
        table.cards td span {
            font-family: 'Poppins', 'DejaVu Sans', sans-serif !important;
        }
        table.cards td:nth-child(2) { border-top-color: #2FB56B; }
        table.cards td:nth-child(3) { border-top-color: #2D52A7; }
        table.cards td:nth-child(4) { border-top-color: #D9D9D9; }

        .card-value {
                font-family: 'Poppins', 'DejaVu Sans', sans-serif !important;
                font-size: 22px;
                font-weight: 700;
                color: #063456;
                line-height: 1;
                text-transform: none;
            }
            .card-label {
                font-family: 'Poppins', 'DejaVu Sans', sans-serif !important;
                font-size: 8px;
                font-weight: 500;
                color: #6b7986;
                margin-top: 6px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            
        /* =========================================================
           DATOS GENERALES (bloque info)
           ========================================================= */
        table.info {
            width: 100%;
            border-collapse: collapse;
            border: 1px solid #E3EBF5;
            border-radius: 6px;
            overflow: hidden;
        }
        table.info td {
            padding: 6px 10px;
            border-bottom: 1px solid #F0F3F9;
            font-size: 9px;
        }
        table.info tr:last-child td { border-bottom: none; }
        table.info td.k {
            width: 22%;
            color: #8a97a3;
            text-transform: uppercase;
            font-size: 8px;
            letter-spacing: 0.4px;
            font-weight: 600;
            background: #F8FAFF;
        }
        table.info td.v {
            width: 28%;
            color: #313845;
            font-weight: 600;
        }

        /* =========================================================
           TABLAS DE DATOS
           ========================================================= */
        table.data {
            width: 100%;
            border-collapse: collapse;
            border: 1px solid #E3EBF5;
            border-radius: 6px;
            overflow: hidden;
        }
        table.data th {
            background: #F8FAFF;
            color: #313845;
            text-align: left;
            padding: 7px 8px;
            font-size: 8px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 1px solid #E3EBF5;
        }
        table.data td {
            padding: 6px 8px;
            border-bottom: 1px solid #F0F3F9;
            font-size: 9px;
            vertical-align: top;
        }
        table.data tr.alt td { background: #FAFBFF; }
        table.data tr:last-child td { border-bottom: none; }
        .num { text-align: right; }

        /* =========================================================
           PREGUNTAS
           ========================================================= */
        .question {
            background: #ffffff;
            border: 1px solid #E3EBF5;
            border-left: 3px solid #4880FF;
            border-radius: 6px;
            padding: 9px 11px;
            margin-bottom: 8px;
            page-break-inside: avoid;
        }
        .q-head {
            font-size: 10px;
            font-weight: 600;
            color: #313845;
            line-height: 1.3;
        }
        .q-num {
            color: #4880FF;
            font-weight: 700;
        }
        .q-meta {
            font-size: 8px;
            color: #8a97a3;
            margin: 3px 0 7px 0;
        }

        /* =========================================================
           BARRAS
           ========================================================= */
        table.bars { width: 100%; border-collapse: collapse; }
        table.bars td { padding: 2px 0; vertical-align: middle; }
        td.bar-label {
            width: 34%;
            font-size: 9px;
            padding-right: 8px;
            color: #313845;
        }
        td.bar-track { width: 46%; }
        .track {
            background: #E8F0F8;
            height: 8px;
            width: 210px;
            border-radius: 4px;
        }
        .fill {
            background: #4880FF;
            height: 8px;
            border-radius: 4px;
        }
        td.bar-value {
            width: 20%;
            font-size: 9px;
            text-align: right;
            color: #313845;
            font-weight: 500;
        }

        .avg {
            font-size: 16px;
            font-weight: 700;
            color: #063456;
            margin: 2px 0 6px 0;
        }
        .avg span {
            font-size: 9px;
            font-weight: 400;
            color: #8a97a3;
        }

        .quote {
            background: #F4F6FD;
            border-left: 2px solid #ACD7FF;
            padding: 5px 8px;
            margin-bottom: 3px;
            font-size: 9px;
            border-radius: 0 4px 4px 0;
            color: #313845;
        }

        /* =========================================================
           BADGES
           ========================================================= */
        .badge {
            display: inline-block;
            padding: 2px 7px;
            border-radius: 4px;
            font-size: 8px;
            font-weight: 600;
            color: #313845;
            background: #F4F6FD;
            border: 1px solid #D2D9DD;
        }
        .badge-published  { background: #E4F7EC; border-color: #9EF18D; color: #1F8F51; }
        .badge-scheduled  { background: #FFF3DA; border-color: #F1B550; color: #8A6D00; }
        .badge-closed     { background: #FDE7E5; border-color: #E42716; color: #B71C0C; }
        .badge-draft      { background: #F1F3F6; border-color: #D9D9D9; color: #6b7986; }

        /* =========================================================
           NOTA / AVISO
           ========================================================= */
        .note {
            background: #FFF7E6;
            border: 1px solid #F1B550;
            border-left: 3px solid #F1B550;
            border-radius: 4px;
            padding: 6px 9px;
            font-size: 9px;
            margin-top: 8px;
            color: #8A6D00;
        }
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