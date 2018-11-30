<?php
// Extend the TCPDF class to create custom MultiRow
class RAnexos10Xls{
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
        $centar = array('alignment' => array(
            'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
            'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
        ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));

        $this->docexcel->getActiveSheet()->setCellValue('A1','EMPRESA: ENDE TRANSMISION S.A.');
        $this->docexcel->getActiveSheet()->setCellValue('A2','GESTION: 2018');
        $this->docexcel->getActiveSheet()->setCellValue('A4','INFORMACION DE PAGOS A BENEFICIARIOS DEL EXTERIOR (EXCEPTO ACTIVIDADES PARCIALMENTE REALIZADAS EN EL PAIS)');
        $this->docexcel->getActiveSheet()->setCellValue('A5','(EXPRESADO EN BOLIVIANOS)');
        $this->docexcel->getActiveSheet()->setCellValue('N1','ANEXO 10');
        $this->docexcel->getActiveSheet()->getStyle('A1:N5')->applyFromArray($titulossubcabezera);

        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(15);

        $this->docexcel->getActiveSheet()->setCellValue('A7','10001');
        $this->docexcel->getActiveSheet()->setCellValue('B7','10002');
        $this->docexcel->getActiveSheet()->setCellValue('C7','10003');
        $this->docexcel->getActiveSheet()->setCellValue('D7','10004');
        $this->docexcel->getActiveSheet()->setCellValue('E7','10005');
        $this->docexcel->getActiveSheet()->setCellValue('F7','10006');
        $this->docexcel->getActiveSheet()->setCellValue('G7','10007');
        $this->docexcel->getActiveSheet()->setCellValue('H7','10008');
        $this->docexcel->getActiveSheet()->setCellValue('I7','10009');
        $this->docexcel->getActiveSheet()->setCellValue('J7','10010');
        $this->docexcel->getActiveSheet()->setCellValue('K7','10011');
        $this->docexcel->getActiveSheet()->setCellValue('L7','10012');
        $this->docexcel->getActiveSheet()->setCellValue('M7','10013');
        $this->docexcel->getActiveSheet()->setCellValue('N7','10014');
        $this->docexcel->getActiveSheet()->getStyle('A7:N7')->applyFromArray($styleTitulos3);

        $this->docexcel->getActiveSheet()->setCellValue('A8','Meses');
        $this->docexcel->getActiveSheet()->setCellValue('B8','IMPORTES SEGÚN ESTADOS FINACIEROS');
        $this->docexcel->getActiveSheet()->setCellValue('G8','Beneficiarios Locales');
        $this->docexcel->getActiveSheet()->setCellValue('H8','Beneficiarios del Exterior Exentos');
        $this->docexcel->getActiveSheet()->setCellValue('I8','SUB TOTAL');
        $this->docexcel->getActiveSheet()->setCellValue('J8','Remesas Pendientes (2)');
        $this->docexcel->getActiveSheet()->setCellValue('K8','Remesas Devengadas en Periodos Anteriores Pagadas en el Periodo (3)');
        $this->docexcel->getActiveSheet()->setCellValue('L8','Total Importe Remesado');
        $this->docexcel->getActiveSheet()->setCellValue('M8','Total Importe Remesado Según Form. 530');
        $this->docexcel->getActiveSheet()->setCellValue('N8','Diferencias (4)');
        $this->docexcel->getActiveSheet()->getStyle('A8:N8')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->mergeCells("B8:F8");
        $this->docexcel->getActiveSheet()->getStyle('A8:N8')->applyFromArray($styleTitulos3);

        $this->docexcel->getActiveSheet()->setCellValue('B9','Intereses');
        $this->docexcel->getActiveSheet()->setCellValue('C9','Servicios');
        $this->docexcel->getActiveSheet()->setCellValue('D9','Otros (1)');
        $this->docexcel->getActiveSheet()->setCellValue('E9','Dividendos');
        $this->docexcel->getActiveSheet()->setCellValue('F9','Total');
        $this->docexcel->getActiveSheet()->getStyle('A9:N9')->applyFromArray($styleTitulos3);

        $this->docexcel->getActiveSheet()->setCellValue('B10','A');
        $this->docexcel->getActiveSheet()->setCellValue('C10','B');
        $this->docexcel->getActiveSheet()->setCellValue('D10','C');
        $this->docexcel->getActiveSheet()->setCellValue('E10','D');
        $this->docexcel->getActiveSheet()->setCellValue('F10','E=A+B+C+D');
        $this->docexcel->getActiveSheet()->setCellValue('G10','F');
        $this->docexcel->getActiveSheet()->setCellValue('H10','G');
        $this->docexcel->getActiveSheet()->setCellValue('I10','H=E-F-G');
        $this->docexcel->getActiveSheet()->setCellValue('J10','I');
        $this->docexcel->getActiveSheet()->setCellValue('K10','J');
        $this->docexcel->getActiveSheet()->setCellValue('L10','K=H-I+J');
        $this->docexcel->getActiveSheet()->setCellValue('M10','I');
        $this->docexcel->getActiveSheet()->setCellValue('N10','M= K-L');
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

        $this->imprimeCabecera();
        $fila = 11;
        $datos = $this->objParam->getParametro('datos');
        $mes_literal = array('ENERO','FEBRERO','MARZO','ABRIL','MAYO','JUNIO','JULIO','AGOSTO','SEPTIEMBRE','OCTUBRE','NOVIEMBRE','DICIEMBRE');
        foreach ($datos as $value){
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $mes_literal[$value['periodo'] - 1]);
            if ($value['periodo'] == '2' || $value['periodo'] == '4'){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, round(abs($value['monto'])));
            }else {
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, round(abs($value['monto'])));
            }

            //// quemado
            if ($value['periodo'] == '1'){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, 62264.3);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila,  173600);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila,   430400);
            }
            if ($value['periodo'] == '2'){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila,  305028.82);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila,  62264);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila,   124528);

            }
            if ($value['periodo'] == '3'){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, 253340.16);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, 422791.82);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, 462640);
            }if ($value['periodo'] == '4'){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, 253340.16);
            }
////por el momneto
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila,0);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila,0);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, '=B'.$fila.'+C'.$fila.'+D'.$fila);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, '=F'.$fila.'-G'.$fila.'-H'.$fila.')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, '=(I'.$fila.'-J'.$fila.'+K'.$fila.')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, '=(L'.$fila.'-M'.$fila.')');
            $this->docexcel->getActiveSheet()->getStyle("B$fila:N$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:O$fila")->applyFromArray($border);

            $fila ++;
            $this->fila_aux = $fila;
        }


        $fill = $this->fila_aux ;
        $fills = $this->fila_aux + 2 ;



        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$fill,'=SUM(B11:B'.($fill-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fill,'=SUM(C11:C'.($fill-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$fill,'=SUM(D11:D'.($fill-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$fill,'=SUM(E11:E'.($fill-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fill,'=SUM(F11:F'.($fill-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6,$fill,'=SUM(G11:G'.($fill-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7,$fill,'=SUM(H11:H'.($fill-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8,$fill,'=SUM(I11:I'.($fill-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9,$fill,'=SUM(J11:J'.($fill-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10,$fill,'=SUM(K11:K'.($fill-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11,$fill,'=SUM(L11:L'.($fill-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12,$fill,'=SUM(M11:M'.($fill-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13,$fill,'=SUM(N11:N'.($fill-1).')');

        $this->docexcel->getActiveSheet()->getStyle("B$fill:N$fills")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
        $this->docexcel->getActiveSheet()->getStyle("A$fill:N$fills")->applyFromArray($total);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fill,'Subtotales');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fill+1,'Ajuste por Inflacion');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fill+2,'Total');

    }
    function generarReporte(){
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);

    }

}
?>

