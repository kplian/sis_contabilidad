<?php
/**
 *@package pXP
 *@file RAuxilarDetalle.php
 *@author  MMV
 *@date 27/12/2018
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 *  	ISUUE			FECHA			AUTHOR 		DESCRIPCION
 *   #23           27/12/2018    Miguel Mamani   Reporte Detalle Auxiliares por Cuenta
 *
 *
 *
 */class RAuxilarDetalle
{
    private $docexcel;
    private $objWriter;
    public $fila_aux = 0;
    public $fil_aux = 0;
    private $equivalencias=array();
    private $objParam;
    public  $url_archivo;
    public $importe_no_identifacdo = array();
    public $diferencia = array();

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
    function datosHeader ($detalle,$nules) {

                        $this->datos_detalle = $detalle;
                        $this->nules = $nules;
    }
    function imprimeCabecera() {

        $this->docexcel->createSheet();
        $this->docexcel->getActiveSheet()->setTitle('Auxiliares');
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

        $datos = $this->datos_detalle;
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'EMPRESA: ENDE TRANSMISION');
        $this->docexcel->getActiveSheet()->getStyle('A1:C1')->applyFromArray($titulossubcabezera);
        $this->docexcel->getActiveSheet()->mergeCells('A1:C1');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,'DETALLE AUXILIARES DE LA CUENTA '.$datos[0]['codigo_aux']);
        $this->docexcel->getActiveSheet()->getStyle('A3:E3')->applyFromArray($titulosCabezera);
        $this->docexcel->getActiveSheet()->mergeCells('A3:E3');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,4,'(Expresado en Bolivianos)');
        $this->docexcel->getActiveSheet()->getStyle('A4:E4')->applyFromArray($titulossubcabezera);
        $this->docexcel->getActiveSheet()->mergeCells('A4:E4');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,5,'Desde: '.date_format(date_create($this->objParam->getParametro('desde')),'d/m/y').' Dasta: '.$this->objParam->getParametro('hasta'));
        $this->docexcel->getActiveSheet()->getStyle('A5:E5')->applyFromArray($titulossubcabezera);
        $this->docexcel->getActiveSheet()->mergeCells('A5:E5');
        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(70);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(25);

        $this->docexcel->getActiveSheet()->setCellValue('A7','CUENTA');
        $this->docexcel->getActiveSheet()->setCellValue('B7','NOMBRE CUENTA Y NOMBRE AUXILIAR');
        $this->docexcel->getActiveSheet()->setCellValue('C7','AUXILIARES');
        $this->docexcel->getActiveSheet()->setCellValue('D7','SALDO AUXILIAR');
        $this->docexcel->getActiveSheet()->setCellValue('E7','SALDO CUENTA');
        $this->docexcel->getActiveSheet()->getStyle('A7:E7')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A7:E7')->applyFromArray($styleTitulos3);
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
                'size'  => 11,
                'name'  => 'Arial'
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );
        $this->imprimeCabecera();
        $fila = 8;
        $datos = $this->datos_detalle;

        foreach ($datos as $value){
            if($value['sw_tipo'] == 'titulo'){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila,$value['codigo']);
            }else{
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fila,$value['codigo']);

            }
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$fila,$value['codigo_aux']);
            if($value['sw_tipo'] == 'titulo'){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$fila,$value['saldo_mb']);
            }else{
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$fila,$value['saldo_mb']);
            }
            $this->docexcel->getActiveSheet()->getStyle("D$fila:E$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:F$fila")->applyFromArray($border);
            $fila ++;
            $this->fila_aux = $fila;
        }
        $fill = $this->fila_aux ;
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fill,'Total');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$fill,'=SUM(D8:D'.($fill -1 ).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$fill,'=SUM(E8:E'.($fill - 1).')');
        $this->docexcel->getActiveSheet()->getStyle("D$fill:E$fill")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
        $this->docexcel->getActiveSheet()->getStyle("A$fill:E$fill")->applyFromArray($total);
        $fille = $this->fila_aux + 3;
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

        $si = count($this->nules);
        if($si > 1) {
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fille, 'Comprobante');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fille, 'Glosa');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fille, 'Fecha');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fille, 'Nro. Cbte');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fille, 'Saldo');
            $this->docexcel->getActiveSheet()->getStyle("A$fille:E$fille")->getAlignment()->setWrapText(true);
            $this->docexcel->getActiveSheet()->getStyle("A$fille:E$fille")->applyFromArray($styleTitulos3);
        }
        $datosNules = $this->nules;
        $filaNuls = $this->fila_aux + 4;
        foreach ($datosNules as $value){
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$filaNuls,$value['id_int_comprobante']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$filaNuls,$value['glosa1']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$filaNuls,date_format(date_create($value['fecha']),'d/m/y'));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$filaNuls,$value['nro_cbte']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$filaNuls,$value['saldo_mb']);
            $this->docexcel->getActiveSheet()->getStyle("E$filaNuls:E$filaNuls")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
            $this->docexcel->getActiveSheet()->getStyle("A$filaNuls:F$filaNuls")->applyFromArray($border);
            $filaNuls++;
            $this->fil_aux = $filaNuls;
        }
        $bill = $this->fil_aux ;
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$bill,'Total');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$bill,'=SUM(E'.($fille +1).':E'.($bill - 1).')');
        $this->docexcel->getActiveSheet()->getStyle("E$bill:E$bill")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
        $this->docexcel->getActiveSheet()->getStyle("A$bill:E$bill")->applyFromArray($total);

    }

    function generarReporte(){
        $this->generarDatos();
        $this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);

    }

}
?>