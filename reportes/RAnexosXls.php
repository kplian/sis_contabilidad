<?php
// Extend the TCPDF class to create custom MultiRow
class RAnexosXls
{
    private $docexcel;
    private $objWriter;
    private $numero;
    private $equivalencias=array();
    private $objParam;
    public  $url_archivo;
    public $fila_aux = 0;
    private $columna1 = array();

    function __construct(CTParametro $objParam)
    {
        $this->objParam = $objParam;
        $this->url_archivo = "../../../reportes_generados/".$this->objParam->getParametro('nombre_archivo');
        set_time_limit(400);
        $cacheMethod = PHPExcel_CachedObjectStorageFactory:: cache_to_phpTemp;
        $cacheSettings = array('memoryCacheSize'  => '10MB');
        PHPExcel_Settings::setCacheStorageMethod($cacheMethod, $cacheSettings);

        $this->docexcel = new PHPExcel();
        $this->docexcel->getProperties()->setCreator("PXP")
            ->setLastModifiedBy("PXP")
            ->setTitle($this->objParam->getParametro('titulo_archivo'))
            ->setSubject($this->objParam->getParametro('titulo_archivo'))
            ->setDescription('Reporte "'.$this->objParam->getParametro('titulo_archivo').'", generado por el framework PXP')
            ->setKeywords("office 2007 openxml php")
            ->setCategory("Report File");
        $this->equivalencias=array( 0=>'A',1=>'B',2=>'C',3=>'D',4=>'E',5=>'F',6=>'G',7=>'H',8=>'I',
            9=>'J',10=>'K',11=>'L',12=>'M',13=>'N',14=>'O',15=>'P',16=>'Q',17=>'R',
            18=>'S',19=>'T',20=>'U',21=>'V',22=>'W',23=>'X',24=>'Y',25=>'Z',
            26=>'AA',27=>'AB',28=>'AC',29=>'AD',30=>'AE',31=>'AF',32=>'AG',33=>'AH',
            34=>'AI',35=>'AJ',36=>'AK',37=>'AL',38=>'AM',39=>'AN',40=>'AO',41=>'AP',
            42=>'AQ',43=>'AR',44=>'AS',45=>'AT',46=>'AU',47=>'AV',48=>'AW',49=>'AX',
            50=>'AY',51=>'AZ',
            52=>'BA',53=>'BB',54=>'BC',55=>'BD',56=>'BE',57=>'BF',58=>'BG',59=>'BH',
            60=>'BI',61=>'BJ',62=>'BK',63=>'BL',64=>'BM',65=>'BN',66=>'BO',67=>'BP',
            68=>'BQ',69=>'BR',70=>'BS',71=>'BT',72=>'BU',73=>'BV',74=>'BW',75=>'BX',
            76=>'BY',77=>'BZ');
    }
    function imprimeCabecera() {
        //estilos
        $titulossubcabezera = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial'
            )
        );
        //
        $styleTitulos2 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => '000000'
                )
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'FFFFFF'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ),
        );
        //
        $styleTitulos3 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => 'FFFFFF'
                )
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '000000'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN,
                    'color' => array('rgb' => 'AAAAAA')
                )
            )
        );
        //Cabecera
        $this->docexcel->createSheet();
        $this->docexcel->getActiveSheet()->setTitle('Anexo 1');
        $this->docexcel->setActiveSheetIndex(0);
        //recuperar datos
        $gestion = $this->objParam->getParametro('gestion');

        $gestion = $gestion['0']['gestion'];
        $this->docexcel->getActiveSheet()->setCellValue('A1','EMPRESA: ENDE TRANSMISION S.A.');
        $this->docexcel->getActiveSheet()->setCellValue('A2','GESTION: '.$gestion);
        $this->docexcel->getActiveSheet()->setCellValue('A4','INFORMACION SOBRE LA DETERMINACION DEL DEBITO FISCAL IVA DECLARADO');
        $this->docexcel->getActiveSheet()->setCellValue('A5','(EXPRESADO EN BOLIVIANOS)');
        $this->docexcel->getActiveSheet()->setCellValue('Q1','ANEXO 1');
        $this->docexcel->getActiveSheet()->getStyle('A1:Q5')->applyFromArray($titulossubcabezera);
        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(12);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(17);
        $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(17);
        $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(17);
        $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(17);
        $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(17);
        $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(17);
        $this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(17);
        $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setWidth(17);

        $this->docexcel->getActiveSheet()->getStyle('A7:Q7')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A7:Q7')->applyFromArray($styleTitulos3);
        $this->docexcel->getActiveSheet()->getStyle('A8:Q8')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A8:Q8')->applyFromArray($styleTitulos3);
        //*************************************Cabecera*****************************************
        $this->docexcel->getActiveSheet()->setCellValue('A7','1001');
        $this->docexcel->getActiveSheet()->setCellValue('B7','1002');
        $this->docexcel->getActiveSheet()->setCellValue('C7','1003');
        $this->docexcel->getActiveSheet()->setCellValue('D7','1004');
        $this->docexcel->getActiveSheet()->setCellValue('E7','1005');
        $this->docexcel->getActiveSheet()->setCellValue('F7','1006');
        $this->docexcel->getActiveSheet()->setCellValue('G7','1007');
        $this->docexcel->getActiveSheet()->setCellValue('H7','1008');
        $this->docexcel->getActiveSheet()->setCellValue('I7','1009');
        $this->docexcel->getActiveSheet()->setCellValue('J7','1010');
        $this->docexcel->getActiveSheet()->setCellValue('K7','1011');
        $this->docexcel->getActiveSheet()->setCellValue('L7','1012');
        $this->docexcel->getActiveSheet()->setCellValue('M7','1013');
        $this->docexcel->getActiveSheet()->setCellValue('N7','1014');
        $this->docexcel->getActiveSheet()->setCellValue('O7','1015');
        $this->docexcel->getActiveSheet()->setCellValue('P7','1016');
        $this->docexcel->getActiveSheet()->setCellValue('Q7','1017');

        $this->docexcel->getActiveSheet()->setCellValue('A8','Meses');
        $this->docexcel->getActiveSheet()->setCellValue('B8','Total ingresos segun Estados Financieros ajustados por inflacion');
        $this->docexcel->getActiveSheet()->setCellValue('C8','Ajuste por Inflación');
        $this->docexcel->getActiveSheet()->setCellValue('D8','Devoluciones Recibidas y Descuentos Otorgados');
        $this->docexcel->getActiveSheet()->setCellValue('E8','Ingresos Devengados en el Periodo no Facturados');
        $this->docexcel->getActiveSheet()->setCellValue('F8','Ingresos Devengados en el Periodo Factura dos en Periodos Anteriores');
        $this->docexcel->getActiveSheet()->setCellValue('G8','Exportaciones');
        $this->docexcel->getActiveSheet()->setCellValue('H8','Ventas Gravadas a Tasa Cero');
        $this->docexcel->getActiveSheet()->setCellValue('I8','Ventas de Activo Fijo y Transacciones Gravadas por el IVA no Registrados en Cuentas de Ingreso');
        $this->docexcel->getActiveSheet()->setCellValue('J8','Otros Ingresos no Gravados (1)');
        $this->docexcel->getActiveSheet()->setCellValue('K8','Ingresos Gravados o Facturados');
        $this->docexcel->getActiveSheet()->setCellValue('L8','Ventas Netas al 100%');
        $this->docexcel->getActiveSheet()->setCellValue('M8','Ingresos Facturados en el Periodo,Devengados en Periodos Anteriores al 100%');
        $this->docexcel->getActiveSheet()->setCellValue('N8','Ingresos Facturados en el Periodo, a Devengar en Periodos Posteriores al 100%');
        $this->docexcel->getActiveSheet()->setCellValue('O8','Total Ingresos Gravados');
        $this->docexcel->getActiveSheet()->setCellValue('P8','Ingresos Declarados Según Form. 200 ó 210');
        $this->docexcel->getActiveSheet()->setCellValue('Q8','Diferencias (2)');


        $this->docexcel->getActiveSheet()->setCellValue('B9','A');
        $this->docexcel->getActiveSheet()->setCellValue('C9','B');
        $this->docexcel->getActiveSheet()->setCellValue('D9','C');
        $this->docexcel->getActiveSheet()->setCellValue('E9','D');
        $this->docexcel->getActiveSheet()->setCellValue('F9','E');
        $this->docexcel->getActiveSheet()->setCellValue('G9','F');
        $this->docexcel->getActiveSheet()->setCellValue('H9','G');
        $this->docexcel->getActiveSheet()->setCellValue('I9','H');
        $this->docexcel->getActiveSheet()->setCellValue('J9','I');
        $this->docexcel->getActiveSheet()->setCellValue('K9','J=A-B-C-D-E-F-G+H-I');
        $this->docexcel->getActiveSheet()->setCellValue('L9','K=J/0,87');
        $this->docexcel->getActiveSheet()->setCellValue('M9','L');
        $this->docexcel->getActiveSheet()->setCellValue('N9','M');
        $this->docexcel->getActiveSheet()->setCellValue('O9','N=K+L+M');
        $this->docexcel->getActiveSheet()->setCellValue('P9','O');
        $this->docexcel->getActiveSheet()->setCellValue('Q9','P=N-O');

        $this->docexcel->getActiveSheet()->getStyle('A9:Q9')->getAlignment()->setWrapText(true);
         $this->docexcel->getActiveSheet()->getStyle('A9:Q9')->applyFromArray($styleTitulos2);

    }

    function generarDatos(){

        $border = array(
            'borders' => array(
                'vertical' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );
        $total= array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial'
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );

        $this->numero = 0;
        $fila = 10;
        $datos = $this->objParam->getParametro('datos');

        $this->imprimeCabecera(0);
        $mes_literal = array('ENERO','FEBRERO','MARZO','ABRIL','MAYO','JUNIO','JULIO','AGOSTO','SEPTIEMBRE','OCTUBRE','NOVIEMBRE','DICIEMBRE');
        foreach ($datos as $value){

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $mes_literal[$value['periodo'] - 1]);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, round(abs($value['monto1'])));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, round(abs($value['monto2'])));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, round(abs($value['monto3'])));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, round(abs($value['monto4'])));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, round(abs($value['monto5'])));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, round(abs($value['monto6'])));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, round(abs($value['monto7'])));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, round(abs($value['monto8'])));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, round(abs($value['monto9'])));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila,'=B'.$fila.'- C'.$fila.'- D'.$fila.'- E'.$fila.'- F'.$fila.'- G'.$fila.'- H'.$fila.'+ I'.$fila.'- J'.$fila);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila,'=K'.$fila.'/0.87');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, 0);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, 0);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, '=L'.$fila.'+M'.$fila.'+N'.$fila);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15, $fila, round(abs($value['monto10'])));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16, $fila, '=O'.$fila.'-P'.$fila);
            $this->docexcel->getActiveSheet()->getStyle("B$fila:Q$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:R$fila")->applyFromArray($border);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila+1,'TOTAL');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$fila+1,'=SUM(B8:B'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fila+1,'=SUM(C8:C'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$fila+1,'=SUM(D8:D'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$fila+1,'=SUM(E8:E'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fila+1,'=SUM(F8:F'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6,$fila+1,'=SUM(G8:G'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7,$fila+1,'=SUM(H8:H'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8,$fila+1,'=SUM(I8:I'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9,$fila+1,'=SUM(J8:J'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10,$fila+1,'=SUM(K8:K'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11,$fila+1,'=SUM(L8:L'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12,$fila+1,'=SUM(M8:M'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13,$fila+1,'=SUM(N8:N'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14,$fila+1,'=SUM(O8:O'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15,$fila+1,'=SUM(P8:P'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16,$fila+1,'=SUM(Q8:Q'.($fila).')');
            $fila++;
            $this->fila_aux = $fila;
        }
        $fill = $this->fila_aux ;
        $this->docexcel->getActiveSheet()->getStyle("A$fill:Q$fill")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
        $this->docexcel->getActiveSheet()->getStyle("A$fill:Q$fill")->applyFromArray($total);

        $styleTitulos3 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => 'FFFFFF'
                )
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '000000'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN,
                    'color' => array('rgb' => 'AAAAAA')
                )
            )
        );
        $fila_detalle = $this->fila_aux + 4;

        $columna = 3;
        foreach ($datos as $value){
           // $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila_detalle,'CODIGO');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila_detalle,'CUENTA');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna, $fila_detalle, $mes_literal[$value['periodo'] - 1]);

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila_detalle + 1, 'Ingresos Intereses MN');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna, $fila_detalle + 1, $value['monto11']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila_detalle + 2, 'Ingresos Reclamos Seguro');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna, $fila_detalle + 2, $value['monto12']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila_detalle + 3, 'Ingresos Ejercicios Anteriores');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna, $fila_detalle + 3, $value['monto13']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila_detalle + 4, 'Ingresos por Redondeo');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna, $fila_detalle + 4, $value['monto14']);
            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[2] . "$fila_detalle:" . $this->equivalencias[$columna + 1 ] . "$fila_detalle")->applyFromArray($styleTitulos3);
            $fill_aux = $fila_detalle + 4;
            $fill_quemado = $fila_detalle + 5;
            $total= array(
                'font'  => array(
                    'bold'  => true,
                    'size'  => 10,
                    'name'  => 'Arial'
                ),
                'borders' => array(
                    'allborders' => array(
                        'style' => PHPExcel_Style_Border::BORDER_THIN
                    )
                )
            );
            $otro_quemando = $fila_detalle + 5;
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila_detalle + 5,"=SUM(".$this->equivalencias[$columna]."$fila_detalle:".$this->equivalencias[$columna]."$fill_aux".")");
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila_detalle + 5, 'Total');
            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[2] . "$otro_quemando:" . $this->equivalencias[$columna + 1 ] . "$otro_quemando")->applyFromArray($total);
            $this->docexcel->getActiveSheet()->getStyle("D22:O$fill_quemado")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
            $boll = $fila_detalle + 1;
            $bull = $fila_detalle + 2;
            $bill = $fila_detalle + 3;
            $bell = $fila_detalle + 4;
            $ball = $fila_detalle + 5;
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna + 1, $boll - 1, "TOTAL");
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna + 1, $boll, "=SUM(".$this->equivalencias[3]."$boll:".$this->equivalencias[$columna] . "$boll)");
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna + 1, $bull, "=SUM(".$this->equivalencias[3]."$bull:".$this->equivalencias[$columna] . "$bull)");
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna + 1, $bill, "=SUM(".$this->equivalencias[3]."$bill:".$this->equivalencias[$columna] . "$bill)");
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna + 1, $bell , "=SUM(".$this->equivalencias[3]."$bell:".$this->equivalencias[$columna] . "$bell)");
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna + 1, $ball , "=SUM(".$this->equivalencias[3]."$ball:".$this->equivalencias[$columna] . "$ball)");
            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[1] . "$fila_detalle:" . $this->equivalencias[$columna + 2 ] . "$fill_quemado")->applyFromArray($border);
            $columna ++;
        }

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $this->fila_aux + 12, "NOTA");
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $this->fila_aux + 12, "1) Se debe agregar una cuenta exclusiva para la venta de Bienes Inmuebles y computar de esta forma, como ingresos no gravados por el IVA, con la finalidad de generar este anexo en forma automática.");
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $this->fila_aux + 13, "2) En el mes de marzo se incluye como ingresos; los Ingresos Diferidos (Cta. 2.2.4.01.002.001 -  Ingresos Diferidos Clientes); por tanto, se paga los impuestos IVA e IT sobre dichos ingresos.");
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $this->fila_aux + 14, "3) Se sugiere agregar un nivel más a la cuenta 4.3.1.01.001 (Otros Ingresos de Administración Central), para que figure como ingresos por redondeo como cuenta de movimiento.");

    }
    function generarReporte(){
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);
    }

}
?>