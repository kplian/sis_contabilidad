<?php
class RLcvXls
{
    private $docexcel;
    private $objWriter;
    private $numero;
    private $equivalencias=array();
    private $objParam;
    public  $url_archivo;
    function __construct(CTParametro $objParam)
    {
        $this->objParam = $objParam;
        $this->url_archivo = "../../../reportes_generados/".$this->objParam->getParametro('nombre_archivo');
        //ini_set('memory_limit','512M');
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
        $this->docexcel->getActiveSheet()->setTitle('Libro Compras');
        $this->docexcel->setActiveSheetIndex(0);

        $styleTitulos1 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 12,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );


        $styleTitulos2 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => 'FFFFFF'
                )

            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '0066CC'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));
        $styleTitulos3 = array(
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

        //titulos

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'LIBRO DE COMPRAS ESTANDAR' );
        $this->docexcel->getActiveSheet()->getStyle('A2:O2')->applyFromArray($styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A2:O2');

        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(30);




        $this->docexcel->getActiveSheet()->getStyle('A5:O5')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A5:O5')->applyFromArray($styleTitulos2);



        //*************************************Cabecera*****************************************
        $this->docexcel->getActiveSheet()->setCellValue('A5','Nº');
        $this->docexcel->getActiveSheet()->setCellValue('B5','FECHA DE LA FACTURA O DUI');
        $this->docexcel->getActiveSheet()->setCellValue('C5','NIT PROVEEDOR');
        $this->docexcel->getActiveSheet()->setCellValue('D5','NOMBRE O RAZON SOCIAL');
        $this->docexcel->getActiveSheet()->setCellValue('E5','Nº DE LA FACTURA');
        $this->docexcel->getActiveSheet()->setCellValue('F5','Nº DE DUI');
        $this->docexcel->getActiveSheet()->setCellValue('G5','Nº DE AUTORIZACION');
        $this->docexcel->getActiveSheet()->setCellValue('H5','MPORTE TOTAL DE LA COMPRAA');
        $this->docexcel->getActiveSheet()->setCellValue('I5','IMPORTE NO SUJETO A CREDITO FISCAL B');

        $this->docexcel->getActiveSheet()->setCellValue('J5','SUBTOTAL C = A - B');
        $this->docexcel->getActiveSheet()->setCellValue('K5','DESCUENTOS BONIFICACION ES Y REBAJAS OBTENIDAS D');
        $this->docexcel->getActiveSheet()->setCellValue('L5','MPORTE BASE PARA CREDITO FISCAL E = C-D');
        $this->docexcel->getActiveSheet()->setCellValue('M5','CREDITO FISCAL F = E*13%');
        $this->docexcel->getActiveSheet()->setCellValue('N5','CODIGO DE CONTROL');
        $this->docexcel->getActiveSheet()->setCellValue('O5','TIPO DE COMPRA');



    }
    function generarDatos()
    {
        $styleTitulos3 = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );

        $this->numero = 1;
        $fila = 6;
        $datos = $this->objParam->getParametro('datos');
        $this->imprimeCabecera(0);
        //var_dump($datos);exit;
        foreach ($datos as $value){
            //if($this->objParam->getParametro('tipo_lcv')=='lcv_compras' || $this->objParam->getParametro('tipo_lcv')=='endesis_erp'||$this->objParam->getParametro('tipo_lcv')=='lcv_ventas'||$this->objParam->getParametro('tipo_lcv')=='LCNCD') {

                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['fecha']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['nit']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['razon_social']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['nro_documento']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['nro_dui']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['nro_autorizacion']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['importe_doc']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['total_excento']);

                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['subtotal']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['importe_descuento']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['sujeto_cf']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, $value['importe_iva']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, $value['codigo_control']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, $value['tipo_doc']);
            //}
            //$this->docexcel->getActiveSheet()->getStyle("E$fila:E$fila")->applyFromArray($styleTitulos3);
            //$this->docexcel->getActiveSheet()->getStyle("I$fila:I$fila")->applyFromArray($styleTitulos3);


            $fila++;
            $this->numero++;

        }
    }
    function generarReporte(){

        //$this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);
        $this->imprimeCabecera(0);

    }

}
?>