<?php
// Extend the TCPDF class to create custom MultiRow
/**
HISTORIAL DE MODIFICACIONES:
ISSUE 		   FECHA   			 AUTOR				 DESCRIPCION:
#22         02/04/2019		  kplina Miguel Mamani	  reporte proyectos excel

 */
class RIntTransaccionMayorExcel
{
    private $docexcel;
    private $objWriter;
    public $fila_aux = 0;
    private $equivalencias=array();
    private $objParam;
    public  $url_archivo;

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
    function datosHeader ( $detalle) {
        $this->datos_detalle = $detalle;
    }
    function imprimeDatos() {

        $this->docexcel->createSheet();
        $this->docexcel->getActiveSheet()->setTitle('Libro Mayor');
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
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
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
                'size'  =>10,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );


        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'EMPRESA: ENDE TRANSMISION');
        $this->docexcel->getActiveSheet()->getStyle('A2:C2')->applyFromArray($titulossubcabezera);
        $this->docexcel->getActiveSheet()->mergeCells('A2:C2');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,'LIBRO MAYOR');
        $this->docexcel->getActiveSheet()->getStyle('A3:O3')->applyFromArray($titulosCabezera);
        $this->docexcel->getActiveSheet()->mergeCells('A3:O3');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,4,'');
        $this->docexcel->getActiveSheet()->getStyle('A4:O4')->applyFromArray($titulossubcabezera);
        $this->docexcel->getActiveSheet()->mergeCells('A4:O4');


        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(12);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(20);

        $this->docexcel->getActiveSheet()->setCellValue('A6','ID Cbte');
        $this->docexcel->getActiveSheet()->setCellValue('B6','Partida');
        $this->docexcel->getActiveSheet()->setCellValue('C6','Cuenta');
        $this->docexcel->getActiveSheet()->setCellValue('D6','Centro Costo');
        $this->docexcel->getActiveSheet()->setCellValue('E6','Glosa');
        $this->docexcel->getActiveSheet()->setCellValue('F6','Debe MB');
        $this->docexcel->getActiveSheet()->setCellValue('G6','Haber MB');
        $this->docexcel->getActiveSheet()->setCellValue('H6','Saldo MB');
        $this->docexcel->getActiveSheet()->setCellValue('I6','Saldo');
        $this->docexcel->getActiveSheet()->setCellValue('J6','Debe MT');
        $this->docexcel->getActiveSheet()->setCellValue('K6','Haber MT');
        $this->docexcel->getActiveSheet()->setCellValue('L6','Saldo MT');
        $this->docexcel->getActiveSheet()->setCellValue('M6','Debe MA');
        $this->docexcel->getActiveSheet()->setCellValue('N6','Haber MA');
        $this->docexcel->getActiveSheet()->setCellValue('O6','Saldo MA');
        $this->docexcel->getActiveSheet()->getStyle('A6:O6')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A6:O6')->applyFromArray($styleTitulos3);

    }
     function generarDatos(){
       $this->imprimeDatos();
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
                 'size'  => 11,
                 'name'  => 'Arial'
             ),
             'borders' => array(
                 'allborders' => array(
                     'style' => PHPExcel_Style_Border::BORDER_THIN
                 )
             )
         );
       $datos = $this->datos_detalle;
       //var_dump($datos);exit;
       $fila = 7;
       foreach ($datos as $value){
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['id_int_comprobante']);
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['desc_cuenta']);
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['desc_partida']);
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['desc_centro_costo']);
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['glosa1']);

           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['importe_debe_mb']);
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['importe_haber_mb']);
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, ($value['importe_debe_mb'] - $value['importe_haber_mb']));
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['dif']);
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['importe_debe_mt']);
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['importe_haber_mt']);
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['importe_debe_ma']);
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, $value['importe_haber_ma']);
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, ($value['importe_debe_mt'] - $value['importe_haber_mt']));
           $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, ($value['importe_debe_ma'] - $value['importe_haber_ma']));
           $this->docexcel->getActiveSheet()->getStyle("F$fila:O$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
           $this->docexcel->getActiveSheet()->getStyle("A$fila:P$fila")->applyFromArray($border);
           $fila ++;
           $this->fila_aux = $fila;
       }
         $fill = $this->fila_aux  ;
         $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fill, 'Total');
         $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fill,'=SUM(F7:F'.($fill - 1).')');
         $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6,$fill,'=SUM(G7:G'.($fill - 1).')');
         $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7,$fill,'=SUM(H7:H'.($fill - 1).')');
         $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8,$fill,'=SUM(I7:I'.($fill - 1).')');
         $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9,$fill,'=SUM(J7:J'.($fill - 1).')');
         $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10,$fill,'=SUM(K7:K'.($fill - 1).')');
         $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11,$fill,'=SUM(L7:L'.($fill - 1).')');
         $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12,$fill,'=SUM(M7:M'.($fill - 1).')');
         $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13,$fill,'=SUM(N7:N'.($fill - 1).')');
         $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14,$fill,'=SUM(O7:O'.($fill - 1).')');
         $this->docexcel->getActiveSheet()->getStyle("F$fill:O$fill")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
         $this->docexcel->getActiveSheet()->getStyle("A$this->fila_aux:P$this->fila_aux")->applyFromArray($total);
     }
    function generarReporte(){
        $this->generarDatos();
        $this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);
    }


}
?>