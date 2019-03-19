<?php
// Extend the TCPDF class to create custom MultiRow
class RAnexos7General{
    private $docexcel;
    private $objWriter;
    public $fila_aux = 0;
    private $equivalencias=array();
    private $objParam;
    public  $url_archivo;
    public $aux ;
    private $monto_anexo ;

    public $a;
    public $b;
    public $c;
    public $d;
    public $e;

    public $aAux;
    public $bAux;
    public $cAux;
    public $dAux;
    public $eAux;

    private $fill_ayuda = 0;

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

        $this->docexcel->createSheet();
        $this->docexcel->getActiveSheet()->setTitle('Anexos 7');
        $this->docexcel->setActiveSheetIndex(0);


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

        $gestion = $this->objParam->getParametro('gestion');
        $this->docexcel->getActiveSheet()->setCellValue('A1','EMPRESA: ENDE TRANSMISION S.A.');
        $this->docexcel->getActiveSheet()->setCellValue('A2','GESTION: 2018');
        $this->docexcel->getActiveSheet()->setCellValue('A4','INFORMACION SOBRE INGRESOS Y GASTOS COMPUTABLES PARA LA DETERMINACION DEL IUE');
        $this->docexcel->getActiveSheet()->setCellValue('A5','(EXPRESADO EN BOLIVIANOS)');
        $this->docexcel->getActiveSheet()->setCellValue('F1','ANEXO 7');

        $this->docexcel->getActiveSheet()->getStyle('A1:Q5')->applyFromArray($titulossubcabezera);
        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(50);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(20);


        $this->docexcel->getActiveSheet()->setCellValue('A7','7001');
        $this->docexcel->getActiveSheet()->setCellValue('B7','7002');
        $this->docexcel->getActiveSheet()->setCellValue('C7','7003');
        $this->docexcel->getActiveSheet()->setCellValue('D7','7004');
        $this->docexcel->getActiveSheet()->setCellValue('E7','7005');
        $this->docexcel->getActiveSheet()->setCellValue('F7','7006');

        $this->docexcel->getActiveSheet()->getStyle('A7:F7')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A7:F7')->applyFromArray($styleTitulos3);

        $this->docexcel->getActiveSheet()->setCellValue('A8','Descripcion');
        $this->docexcel->getActiveSheet()->setCellValue('B8','Total Según Estados Financieros');
        $this->docexcel->getActiveSheet()->setCellValue('C8','INGRESOS');
        $this->docexcel->getActiveSheet()->mergeCells('C8:D8');
        // $this->docexcel->getActiveSheet()->setCellValue('D8','Saldo Final del Anticipo');
        $this->docexcel->getActiveSheet()->setCellValue('E8','GASTOS');
        $this->docexcel->getActiveSheet()->mergeCells('E8:F8');
        //$this->docexcel->getActiveSheet()->setCellValue('F8','Saldo Final del Anticipo');
        $this->docexcel->getActiveSheet()->getStyle('A8:F8')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A8:F8')->applyFromArray($styleTitulos3);
        $this->docexcel->getActiveSheet()->setCellValue('C9','Imponibles');
        $this->docexcel->getActiveSheet()->setCellValue('D9','No Imponibles');
        $this->docexcel->getActiveSheet()->setCellValue('E9','Deducibles');
        $this->docexcel->getActiveSheet()->setCellValue('F9','No Deducibles');
        $this->docexcel->getActiveSheet()->getStyle('A9:F9')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A9:F9')->applyFromArray($styleTitulos3);
        //
        $this->docexcel->getActiveSheet()->setCellValue('A10','A');
        $this->docexcel->getActiveSheet()->setCellValue('B10','B');
        $this->docexcel->getActiveSheet()->setCellValue('C10','C');
        $this->docexcel->getActiveSheet()->setCellValue('D10','D');
        $this->docexcel->getActiveSheet()->setCellValue('E10','E');
        $this->docexcel->getActiveSheet()->setCellValue('F10','F');

        $this->docexcel->getActiveSheet()->getStyle('A10:F10')->applyFromArray($centar);
    }
    function generarDatos(){
        $border = array(
            'borders' => array(
                'vertical' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );
        $styleTitulos = array(
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
        $styleTitulos2 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial'
            )
        );
        $styleTitulos3 = array(

            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );
        $this->imprimeCabecera();
        $fila = 11;
        $datos = $this->objParam->getParametro('datos');
        foreach ( $datos as $monto){

            if($monto['codigo_columna'] == 'ANE8'){
                $this->monto_anexo = round(abs($monto['monto_a']));
            }


            if($monto['titulo'] == 'GASTOS'){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila,'=SUM(B12:B'.($fila-1).')');
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila,'=SUM(C12:C'.($fila-1).')');
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila,'=SUM(D12:D'.($fila-1).')');
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila,'=SUM(E12:E'.($fila-1).')');
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila,'=SUM(F12:F'.($fila-1).')');
                $this->a='=B'.$fila;
                $this->b='=C'.$fila;
                $this->c='=D'.$fila;
                $this->d='=E'.$fila;
                $this->e='=F'.$fila;
                $this->docexcel->getActiveSheet()->getStyle("B$fila:F$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
                $this->docexcel->getActiveSheet()->getStyle("A$fila:F$fila")->applyFromArray($styleTitulos);
                $fila = $fila + 1;
                $this->fill_ayuda =$fila ;
            }
            if($monto['codigo_columna'] != 'ANE8') {
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $monto['titulo']);

                if ($monto['titulo'] != 'INGRESOS') {
                    if ($monto['titulo'] != 'GASTOS') {

                        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, round(abs($monto['monto_a'])));
                        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, round(abs($monto['monto_b'])));
                        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, round(abs($monto['monto_c'])));
                        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, round(abs($monto['monto_d'])));
                        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, round(abs($monto['monto_e'])));


                    }
                }
                $this->docexcel->getActiveSheet()->getStyle("B$fila:F$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
                $this->docexcel->getActiveSheet()->getStyle("A$fila:G$fila")->applyFromArray($border);
                $fila++;
                $this->aux = $fila;
            }
        }
        $fill = $this->aux;
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$fill, '=SUM(B'.$this->fill_ayuda.':B'.($fill-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fill ,'=SUM(C'.$this->fill_ayuda.':C'.($fill-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$fill ,'=SUM(D'.$this->fill_ayuda.':D'.($fill-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$fill ,'=SUM(E'.$this->fill_ayuda.':E'.($fill-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fill ,'=SUM(F'.$this->fill_ayuda.':F'.($fill-1).')');
        $this->aAux='-B'.$fill;
        $this->bAux='+C'.$fill;
        $this->cAux='+D'.$fill;
        $this->dAux='+E'.$fill;
        $this->eAux='+F'.$fill;
        $this->docexcel->getActiveSheet()->getStyle("B$fill:F$fill")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
        $this->docexcel->getActiveSheet()->getStyle("A$fill:F$fill")->applyFromArray($styleTitulos3);

        $BStyle = array(
            'borders' => array(
                'outline' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );
        //

        $uyuda = $fill + 1;
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$uyuda, 'RESULTADO DE LA GESTION');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$uyuda ,$this->a.$this->aAux);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$uyuda ,$this->b.$this->bAux);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$uyuda ,$this->c.$this->cAux);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$uyuda ,$this->d.$this->dAux);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$uyuda ,$this->e.$this->eAux);
        $this->docexcel->getActiveSheet()->getStyle("A$uyuda:F$uyuda")->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->getStyle("B$uyuda:F$uyuda")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$uyuda+1, '(MENOS)');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$uyuda+2, 'INGRESOS NO IMPONIBLES');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$uyuda+2, $this->c.$this->cAux);
        $la = $uyuda+2;
        $this->docexcel->getActiveSheet()->getStyle("B$la:B$la")->applyFromArray($styleTitulos2);
        $this->docexcel->getActiveSheet()->getStyle("B$la:B$la")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$uyuda+4, 'MAS:');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$uyuda+6, 'GASTOS NO DEDUCIBLES');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$uyuda+6, $this->e.$this->eAux);
        $lu = $uyuda+6;
        $this->docexcel->getActiveSheet()->getStyle("B$lu:B$lu")->applyFromArray($styleTitulos2);
        $this->docexcel->getActiveSheet()->getStyle("B$lu:B$lu")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
        $pe= $uyuda+8;
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$uyuda+8, 'MAS/(MENOS):');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$uyuda+9, 'OTRAS REGULARIZACIONES (Anexo No.8)');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$uyuda+8, $this->monto_anexo);

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$uyuda+10, 'RESULTADO TRIBUTARIO');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$uyuda+10, '=B'.$uyuda.'-B'.$la.'+B'.$lu.'-B'.$pe);
        $lo = $uyuda+10;
        $this->docexcel->getActiveSheet()->getStyle("A$lo:A$lo")->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->getStyle("B$pe:B$pe")->applyFromArray($styleTitulos2);
        $this->docexcel->getActiveSheet()->getStyle("B$pe:B$pe")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
        $this->docexcel->getActiveSheet()->getStyle("B$lo:B$lo")->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->getStyle("B$lo:B$lo")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);

        $this->docexcel->getActiveSheet()->getStyle("A$uyuda:A$lo")->applyFromArray($BStyle);
        $this->docexcel->getActiveSheet()->getStyle("B$uyuda:B$lo")->applyFromArray($BStyle);
    }

    function generarReporte(){
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);

    }

}
?>

