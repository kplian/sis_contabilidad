<?php
// Extend the TCPDF class to create custom MultiRow
class RAnexos11General{
    private $docexcel;
    private $objWriter;
    public $fila_aux = 0;
    private $equivalencias=array();
    private $objParam;
    public  $url_archivo;
    public $aux ;


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
        $this->docexcel->getActiveSheet()->setTitle('Anexos 11');
        $this->docexcel->setActiveSheetIndex(0);


        $titulossubcabezera = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial'
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

        $this->docexcel->getActiveSheet()->setCellValue('A1','EMPRESA: ENDE TRANSMISION S.A.');
        $this->docexcel->getActiveSheet()->setCellValue('A2','GESTION: 2018');
        $this->docexcel->getActiveSheet()->setCellValue('A4','INFORMACION SOBRE LOS SALDOS DE LAS CUENTAS DE LOS ESTADOS FINANCIEROS RELACIONADOS CON IMPUESTOS');
        $this->docexcel->getActiveSheet()->setCellValue('A5','(EXPRESADO EN BOLIVIANOS)');
        $this->docexcel->getActiveSheet()->setCellValue('B1','ANEXO 11');
        $this->docexcel->getActiveSheet()->getStyle('A1:B5')->applyFromArray($titulossubcabezera);

        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(70);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(50);


        $this->docexcel->getActiveSheet()->setCellValue('A7','11001');
        $this->docexcel->getActiveSheet()->setCellValue('B7','11002');
        $this->docexcel->getActiveSheet()->getStyle('A7:B7')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A7:B7')->applyFromArray($styleTitulos3);

        $this->docexcel->getActiveSheet()->setCellValue('A8','Cuentas');
        $this->docexcel->getActiveSheet()->setCellValue('B8','Saldos Según  Estados Financieros');

        $this->docexcel->getActiveSheet()->getStyle('A8:B8')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A8:B8')->applyFromArray($styleTitulos3);

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

        $this->imprimeCabecera();
        $fila = 9;
        $datos = $this->objParam->getParametro('datos');
        foreach ( $datos as $monto){
            if($monto['titulo'] == 'PASIVO'){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila,'Total');
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila,'=SUM(B10:B'.($fila-1).')');
                $this->docexcel->getActiveSheet()->getStyle("B$fila:B$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
                $this->docexcel->getActiveSheet()->getStyle("A$fila:B$fila")->applyFromArray($styleTitulos);
                $fila = $fila +1 ;
            }
            if($monto['titulo'] == 'RESULTADOS'){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila,'Total');
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila,'=SUM(B14:B'.($fila-1).')');
                $this->docexcel->getActiveSheet()->getStyle("B$fila:B$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
                $this->docexcel->getActiveSheet()->getStyle("A$fila:B$fila")->applyFromArray($styleTitulos);
                $fila = $fila +1 ;
            } if($monto['titulo'] == 'CONTINGENTES'){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila,'Total');
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila,'=SUM(B28:B'.($fila-1).')');
                $this->docexcel->getActiveSheet()->getStyle("B$fila:B$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
                $this->docexcel->getActiveSheet()->getStyle("A$fila:B$fila")->applyFromArray($styleTitulos);
                $fila = $fila +1 ;
            }
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $monto['titulo']);
            if($monto['titulo'] != 'ACTIVO') {
                if($monto['titulo'] != 'PASIVO') {
                    if($monto['titulo'] != 'RESULTADOS') {
                        if($monto['titulo'] != 'CONTINGENTES') {
                            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, round(abs($monto['monto_a'])));
                        }
                    }
                }
            }
            $this->docexcel->getActiveSheet()->getStyle("B$fila:B$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:C$fila")->applyFromArray($border);
            $fila++;
            $this->fila_aux = $fila;
        }
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$this->fila_aux,'Total');
        //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$this->fila_aux ,'=SUM(B38:B'.($this->fila_aux).')');
        $this->docexcel->getActiveSheet()->getStyle("A$this->fila_aux:B$this->fila_aux")->applyFromArray($styleTitulos);
    }
    function generarReporte(){
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);

    }

}
?>

