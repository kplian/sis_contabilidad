<?php
/**
 *@package pXP
 *@file RCuadroActualizacion.php
 *@author  Gonzalo Sarmiento Sejas
 *@date 21-02-2013 15:04:03
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
ISSUE			FECHA 				AUTHOR 						DESCRIPCION
#28	     	17/12/2018			    MMV							Reporte cuadro de actualización

 */
class RCuadroActualizacion
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

    function imprimeCabecera() {

        $this->docexcel->createSheet();
        $this->docexcel->getActiveSheet()->setTitle('Anexos 2');
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
                'size'  => 10,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );

        $styleTitulos3 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial'

            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );

        $datos = $this->objParam->getParametro('datos');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'EMPRESA: ENDE TRANSMISION');
        $this->docexcel->getActiveSheet()->getStyle('A2:C2')->applyFromArray($titulossubcabezera);
        $this->docexcel->getActiveSheet()->mergeCells('A2:C2');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,'CUADRO DE ACTUALIZACION '. strtoupper ($this->objParam->getParametro('tipo_cuenta')));
        $this->docexcel->getActiveSheet()->getStyle('A3:H3')->applyFromArray($titulosCabezera);
        $this->docexcel->getActiveSheet()->mergeCells('A3:H3');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,4,'Tipo Cambio: '.$this->objParam->getParametro('tipo_moneda').' ('.$datos[0]['tipo_cambio'].') Fecha Tipo Cambio: '.$this->objParam->getParametro('fecha_moneda'));
        $this->docexcel->getActiveSheet()->getStyle('A4:H4')->applyFromArray($titulossubcabezera);
        $this->docexcel->getActiveSheet()->mergeCells('A4:H4');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,5,'Del: '.$this->objParam->getParametro('desde').' Al: '.$this->objParam->getParametro('hasta'));
        $this->docexcel->getActiveSheet()->getStyle('A5:H5')->applyFromArray($titulossubcabezera);
        $this->docexcel->getActiveSheet()->mergeCells('A5:H5');

        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(25);

        $this->docexcel->getActiveSheet()->setCellValue('A7','Codigo (1)');
        $this->docexcel->getActiveSheet()->setCellValue('B7','Cuenta (2)');
        $this->docexcel->getActiveSheet()->setCellValue('C7','Debe '.$this->objParam->getParametro('tipo_moneda').' (3)');
        $this->docexcel->getActiveSheet()->setCellValue('D7','Haber '.$this->objParam->getParametro('tipo_moneda').' (4)');
        $this->docexcel->getActiveSheet()->setCellValue('E7','Saldo '.$this->objParam->getParametro('tipo_moneda').' (5)');
        $this->docexcel->getActiveSheet()->setCellValue('F7','Importe en Bolivianos (6)');
        $this->docexcel->getActiveSheet()->setCellValue('G7','Saldo de mayor a Nivel en Bs.(7)');
        $this->docexcel->getActiveSheet()->setCellValue('H7','Monto a Actualizar (8)');
        $this->docexcel->getActiveSheet()->getStyle('A7:H7')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A7:H7')->applyFromArray($styleTitulos3);


    }
    function generarDatos(){
        $aliniar = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_LEFT
                //'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
            )
        );
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
            )
        );
        $movimiento= array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => '136C26'
                )
            )
        );
        $borderFinal = array(
            'borders' => array(
                'bottom' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );
        $this->imprimeCabecera();
        $fila = 8;
        $datos = $this->objParam->getParametro('datos');

        foreach ($datos as $value){
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['nro_cuenta']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['nombre_cuenta']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['debe_ma']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['haber_ma']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['saldo_ma']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['importe_mb']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['saldo_mayor']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['saldo_actulizacion']);
           // $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['nivel']);
            $this->docexcel->getActiveSheet()->getStyle("C$fila:H$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:A$fila")->applyFromArray($aliniar);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:I$fila")->applyFromArray($border);

            $fila ++;
        }
        $fill = $fila - 1;
        $this->docexcel->getActiveSheet()->getStyle("A$fill:H$fill")->applyFromArray($borderFinal);


    }

    function generarReporte(){
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);

    }

}
?>