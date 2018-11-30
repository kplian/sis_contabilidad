<?php
// Extend the TCPDF class to create custom MultiRow
class RAnexos5Xls{
    private $docexcel;
    private $objWriter;
    public $fila_aux = 0;
    private $equivalencias=array();
    private $objParam;
    public  $url_archivo;
    private $totala1;
    private $totala2;

    private $totalb1;
    private $totalb2;
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
        $this->docexcel->getActiveSheet()->setTitle('Anexos 5');
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

        $this->docexcel->getActiveSheet()->setCellValue('A1','EMPRESA: ENDE TRANSMISION S.A.');
        $this->docexcel->getActiveSheet()->setCellValue('A2','GESTION: '.$this->objParam->getParametro('datos')[0]['gestion']);

        $this->docexcel->getActiveSheet()->setCellValue('A4','INFORMACION DE LA COMPENSACION DEL IT CON EL IUE');
        $this->docexcel->getActiveSheet()->setCellValue('A5','(EXPRESADO EN BOLIVIANOS)');
        $this->docexcel->getActiveSheet()->setCellValue('D1','ANEXO 5');
        $this->docexcel->getActiveSheet()->getStyle('A1:D5')->applyFromArray($titulossubcabezera);


        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(12);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(25);

        $this->docexcel->getActiveSheet()->setCellValue('A7','5001');
        $this->docexcel->getActiveSheet()->setCellValue('B7','5002');
        $this->docexcel->getActiveSheet()->setCellValue('C7','5003');
        $this->docexcel->getActiveSheet()->setCellValue('D7','5004');

        $this->docexcel->getActiveSheet()->getStyle('A7:D7')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A7:D7')->applyFromArray($styleTitulos3);

        $this->docexcel->getActiveSheet()->setCellValue('A8','Meses');
        $this->docexcel->getActiveSheet()->setCellValue('B8','Saldo IUE Pagado');
        $this->docexcel->getActiveSheet()->setCellValue('C8','IT Compensado');
        $this->docexcel->getActiveSheet()->setCellValue('D8','Saldo Final del Anticipo');

        $this->docexcel->getActiveSheet()->getStyle('A8:D8')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A8:D8')->applyFromArray($styleTitulos3);
        //
        $this->docexcel->getActiveSheet()->setCellValue('B9','A');
        $this->docexcel->getActiveSheet()->setCellValue('C9','B');
        $this->docexcel->getActiveSheet()->setCellValue('D9','C = A - B ');


        $this->docexcel->getActiveSheet()->getStyle('A9:D9')->applyFromArray($centar);
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
        $fila = 10;
        $datos = $this->objParam->getParametro('datos');

        //var_dump($datos);exit;
        $titulo = 'tipo';
        $mes_literal = array('ENERO','FEBRERO','MARZO','ABRIL','MAYO','JUNIO','JULIO','AGOSTO','SEPTIEMBRE','OCTUBRE','NOVIEMBRE','DICIEMBRE');
        foreach ($datos as $value){
            if($value['tipo']!='saldo') {
                if ($value['tipo'] != 'it') {
                    if ($value['tipo'] != $titulo) {
                        $this->imprimeSubtitulo($fila, $value['tipo'], $value['saldo']);
                        $titulo = $value['tipo'];
                        $fila++;
                    }
                }
            }
            if($value['tipo'] == 'saldo' || $value['tipo'] == 'it'){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $mes_literal[$value['periodo'] - 1]);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['saldo']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['it']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['operacion']);
                $this->docexcel->getActiveSheet()->getStyle("B$fila:D$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
                $this->docexcel->getActiveSheet()->getStyle("A$fila:E$fila")->applyFromArray($border);

                $fila++;
                $this->fila_aux = $fila;
            }
        }
        $fill = $this->fila_aux +1 ;
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fill, 'Total');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fill,$this->totala1.$this->totala2);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fill,$this->totalb1.$this->totalb2);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fill,'=B'.$fill.'- C'.$fill);
        $this->docexcel->getActiveSheet()->getStyle("A$fill:D$fill")->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->getStyle("B$fill:D$fill")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);

    }
    function imprimeSubtitulo($fila, $valor,$valor2) {
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

        $this->docexcel->getActiveSheet()->getStyle("A$fila:D$fila")->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila,$valor);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila,$valor2);
        if ($valor == 'Subtotal 1'){
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila,'=SUM(C10:C'.($fila-1).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila,'=B'.$fila.'- C'.$fila);
            $this->totala1 = '=B'.$fila;
            $this->totalb1 = '=C'.$fila;
        }else{
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila,'=SUM(C15:C'.($fila-1).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila,'=B'.$fila.'- C'.$fila);
            $this->totala2 = '+B'.$fila;
            $this->totalb2 = '+C'.$fila;
        }
        $this->docexcel->getActiveSheet()->getStyle("B$fila:D$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
    }

    function generarReporte(){
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);

    }

}
?>