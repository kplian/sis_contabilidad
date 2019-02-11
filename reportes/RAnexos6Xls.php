<?php
// Extend the TCPDF class to create custom MultiRow
class RAnexos6Xls
{
    private $docexcel;
    private $objWriter;
    public  $fila_aux = 0;
    public $columna_aux = 0;
    private $equivalencias=array();
    private $objParam;
    public  $url_archivo;
    private $detalle = array();
    private  $otra = 0;

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
    function datosHeader ($datos ,$datos_aux) {
        $this->datos = $datos;
        $this->datos_aux = $datos_aux;

       // var_dump($this->datos);exit;
    }
    function imprimeCabecera() {

        $this->docexcel->createSheet();
        $this->docexcel->getActiveSheet()->setTitle('Anexos 6');
        $this->docexcel->setActiveSheetIndex(0);

        $titulosCabezera = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 11,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );
        $titulossubcabezera = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial'
            )
        );
        $centar = array('alignment' => array(
            'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
            'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
        ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));
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


        $this->docexcel->getActiveSheet()->setCellValue('A1','EMPRESA: ENDE TRANSMISION S.A.');
        $this->docexcel->getActiveSheet()->setCellValue('A2','GESTION: '.$this->objParam->getParametro('datos')[0]['gestion']);

        $this->docexcel->getActiveSheet()->setCellValue('A4','INFORMACION RELACIONADA CON EL RC-IVA DEPENDIENTES');
        $this->docexcel->getActiveSheet()->setCellValue('A5','(EXPRESADO EN BOLIVIANOS)');
        $this->docexcel->getActiveSheet()->setCellValue('N1','ANEXO 6');
        $this->docexcel->getActiveSheet()->getStyle('A1:N5')->applyFromArray($titulossubcabezera);


        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(25);

        $this->docexcel->getActiveSheet()->setCellValue('A7','6001');
        $this->docexcel->getActiveSheet()->setCellValue('B7','6002');
        $this->docexcel->getActiveSheet()->setCellValue('C7','6003');
        $this->docexcel->getActiveSheet()->setCellValue('D7','6004');
        $this->docexcel->getActiveSheet()->setCellValue('E7','6005');
        $this->docexcel->getActiveSheet()->setCellValue('F7','6006');
        $this->docexcel->getActiveSheet()->setCellValue('G7','6007');
        $this->docexcel->getActiveSheet()->setCellValue('H7','6008');
        $this->docexcel->getActiveSheet()->setCellValue('I7','6009');
        $this->docexcel->getActiveSheet()->setCellValue('J7','6010');
        $this->docexcel->getActiveSheet()->setCellValue('K7','6011');
        $this->docexcel->getActiveSheet()->setCellValue('L7','6012');
        $this->docexcel->getActiveSheet()->setCellValue('M7','6013');
        $this->docexcel->getActiveSheet()->setCellValue('N7','6014');

        $this->docexcel->getActiveSheet()->getStyle('A7:N7')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A7:N7')->applyFromArray($styleTitulos3);

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,8,'SEGÚN ESTADOS FINANCIEROS');
        $this->docexcel->getActiveSheet()->getStyle('A8:N8')->applyFromArray($titulosCabezera);
        $this->docexcel->getActiveSheet()->mergeCells('A8:N8');

        $this->docexcel->getActiveSheet()->setCellValue('A9','Detalle');
        $this->docexcel->getActiveSheet()->setCellValue('B9','Sueldos y Salarios');
        $this->docexcel->getActiveSheet()->setCellValue('C9','Bonos');
        $this->docexcel->getActiveSheet()->setCellValue('D9','Horas Extras');
        $this->docexcel->getActiveSheet()->setCellValue('E9','Otros Pagos');
        $this->docexcel->getActiveSheet()->setCellValue('F9','Total Pagos al Personal');
        $this->docexcel->getActiveSheet()->setCellValue('G9','Remuneraciones Pendientes de Pago de Periodos Anteriores Pagados en el Periodo');
        $this->docexcel->getActiveSheet()->setCellValue('H9','Remuneraciones Pendientes de Pago del Periodo Analizado');
        $this->docexcel->getActiveSheet()->setCellValue('I9','Conceptos no Sujetos a RC - IVA (2)');
        $this->docexcel->getActiveSheet()->setCellValue('J9','Total Remuneracion Pagado en el Periodo');
        $this->docexcel->getActiveSheet()->setCellValue('K9','Aportes Laborales a Seguridad');
        $this->docexcel->getActiveSheet()->setCellValue('L9','Total Sueldos Netos Computables Sujetos al RC - IVA  Según Estados Financieros');
        $this->docexcel->getActiveSheet()->setCellValue('M9','Total Sueldos Netos Computables Sujetos al RC - IVA Según Form.608');
        $this->docexcel->getActiveSheet()->setCellValue('N9','Diferencia(3)');

        $this->docexcel->getActiveSheet()->getStyle('A8:N9')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A8:N9')->applyFromArray($styleTitulos3);
        //

        $this->docexcel->getActiveSheet()->setCellValue('B10','A');
        $this->docexcel->getActiveSheet()->setCellValue('C10','B');
        $this->docexcel->getActiveSheet()->setCellValue('D10','C');
        $this->docexcel->getActiveSheet()->setCellValue('E10','D');
        $this->docexcel->getActiveSheet()->setCellValue('F10','E=(A+B+C+D)');
        $this->docexcel->getActiveSheet()->setCellValue('G10','F');
        $this->docexcel->getActiveSheet()->setCellValue('H10','G');
        $this->docexcel->getActiveSheet()->setCellValue('I10','H');
        $this->docexcel->getActiveSheet()->setCellValue('J10','I=E+F-G-H');
        $this->docexcel->getActiveSheet()->setCellValue('K10','J');
        $this->docexcel->getActiveSheet()->setCellValue('L10','K=I-J');
        $this->docexcel->getActiveSheet()->setCellValue('M10','L');
        $this->docexcel->getActiveSheet()->setCellValue('N10','M=K-L');

        $this->docexcel->getActiveSheet()->getStyle('A9:N10')->applyFromArray($centar);
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
                'size'  => 9,
                'name'  => 'Arial'
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );
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
        $this->imprimeCabecera();
        $fila = 11;
        $datos = $this->datos;

        $mes_literal = array('ENERO','FEBRERO','MARZO','ABRIL','MAYO','JUNIO','JULIO','AGOSTO','SEPTIEMBRE','OCTUBRE','NOVIEMBRE','DICIEMBRE');
        foreach ($datos as $value){
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $mes_literal[$value['periodo'] - 1]);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, round(abs($value['monto_a'])));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, round(abs($value['monto_b'])));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, round(abs($value['monto_c'])));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, round(abs($value['monto_d'])));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, '= B'.$fila.'+C'.$fila.'+D'.$fila.'+E'.$fila);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, 0);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, 0);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, 0);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, '=(F'.$fila.'+G'.$fila.'-H'.$fila.'-I'.$fila.')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, round(abs($value['monto_j'])));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila,'=(J'.$fila.'-K'.$fila.')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, round(abs($value['monto_l'])));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila,'=(L'.$fila.'-M'.$fila.')');
            $this->docexcel->getActiveSheet()->getStyle("B$fila:N$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:O$fila")->applyFromArray($border);

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila+1,'Subtotal');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$fila+1,'=SUM(B10:B'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fila+1,'=SUM(C10:C'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$fila+1,'=SUM(D10:D'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$fila+1,'=SUM(E10:E'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fila+1,'=SUM(F10:F'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6,$fila+1,'=SUM(G10:G'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7,$fila+1,'=SUM(H10:H'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8,$fila+1,'=SUM(I10:I'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9,$fila+1,'=SUM(J10:J'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10,$fila+1,'=SUM(K10:K'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11,$fila+1,'=SUM(L10:L'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12,$fila+1,'=SUM(M10:M'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13,$fila+1,'=SUM(N10:N'.($fila).')');
            $fila++;
            $this->fila_aux = $fila;
        }
        //var_dump($this->fila_aux);exit;
        $fill = $this->fila_aux ;
        $this->docexcel->getActiveSheet()->getStyle("B$fill:N$fill")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
        $this->docexcel->getActiveSheet()->getStyle("A$fill:N$fill")->applyFromArray($total);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fill+1,'Ajuste por Inflacion');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fill+2,'Total');
        $ayuda = $fill + 1;$ayuda2 = $fill + 2;
        $this->docexcel->getActiveSheet()->getStyle("A$ayuda:N$ayuda")->applyFromArray($total);
        $this->docexcel->getActiveSheet()->getStyle("A$ayuda2:N$ayuda2")->applyFromArray($total);

        $columna = 2;
        $datos_aux =$this->datos;
        $esc = $this->fila_aux +5;
        $detalle =$this->datos_aux;


        //var_dump($detalle);exit;
        foreach ($detalle as $values ){

            if (!array_key_exists($values['nro_cuenta'], $this->detalle) ||
                !array_key_exists($values['codigo_partida'], $this->detalle[$values['nro_cuenta']]) ||
                !array_key_exists($values['periodo'], $this->detalle[$values['nro_cuenta']][$values['codigo_partida']]) ||
                !array_key_exists($values['importe'], $this->detalle[$values['nro_cuenta']][$values['codigo_partida']][$values['periodo']])) {

                $this->detalle[$values['nro_cuenta']][$values['codigo_partida']][$values['periodo']][$values['importe']]= 1;
            } else {

                $this->detalle[$values['nro_cuenta']][$values['codigo_partida']][$values['periodo']][$values['importe']] ++;
            }
        }
        $this->columna_aux = 2 ;
        $reg =  '';
        $fila_detalle = $this->fila_aux  + 6;
        $fila_total = $this->fila_aux  + 7;
        $prue = $this->fila_aux  + 6;
        foreach ($this->detalle  as $key => $cuenta ){
            foreach ($cuenta as $key2 => $partida ){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila_detalle,$key);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila_detalle,$key2);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila_detalle + 1, "TOTAL");
                    if ($partida != $reg) {
                        $reg = $partida;
                        $this->columna_aux  = 2;
                    }else{
                        $this->columna_aux  = 2;
                    }

                foreach ($partida as $Key3 => $monto ){
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$esc,'CUENTA');
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$esc,'PARTIDA');
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($this->columna_aux,  $this->fila_aux + 5, $mes_literal[$Key3 -1 ] );
                    $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[0] . "$esc:" . $this->equivalencias[$this->columna_aux + 1 ] . "$esc")->applyFromArray($styleTitulos3);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $prue -1, "TOTAL");
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila_detalle ,"=SUM(".$this->equivalencias[2]."$fila_detalle:".$this->equivalencias[$this->columna_aux ]."$fila_detalle".")");
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila_detalle + 1 ,'=SUM(O27:O'.($fila_detalle ).')');

                    foreach ($monto as $key4 => $bool){
                        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($this->columna_aux , $fila_detalle,$key4);
                        $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[2] . "$fila_detalle:" . $this->equivalencias[$this->columna_aux + 2 ] . "$fila_detalle")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
                        $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[0] . "$fila_detalle:" . $this->equivalencias[$this->columna_aux + 2 ] . "$fila_detalle")->applyFromArray($border);
                        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila_detalle + 1, "TOTAL");
                        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($this->columna_aux,$fila_detalle + 1,"=SUM(".$this->equivalencias[$this->columna_aux]."$prue:".$this->equivalencias[$this->columna_aux ]."$fila_detalle".")");
                    }
                    $this->columna_aux  ++;
                }

                $fila_detalle ++;
                $this->otra =  $fila_detalle;
            }
        }
        $this->docexcel->getActiveSheet()->getStyle("C$this->otra:O$this->otra")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
        $this->docexcel->getActiveSheet()->getStyle("B$this->otra:O$this->otra")->applyFromArray($total);
    }

    function generarReporte(){
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);


    }

}
?>



