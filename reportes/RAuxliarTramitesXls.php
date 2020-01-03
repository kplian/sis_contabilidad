<?php
/**
 *@package pXP
 *@file gen-MODIntTransaccion.php
 *@author  (admin)
 *@date 01-09-2013 18:10:12
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */
/**
HISTORIAL DE MODIFICACIONES:
ISSUE 		   FECHA   			 AUTOR				 DESCRIPCION:
#83 		 03/01/2020		  Miguel Mamani	  Reporte Auxiliares aumentar columna beneficiario

 */
class RAuxliarTramitesXls
{
    private $docexcel;
    private $objWriter;
    private $numero;
    private $equivalencias=array();
    private $objParam;
    public  $url_archivo;
    public $fila_aux = 0;
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
        $datos = $this->objParam->getParametro('datos');
        $styleTitulos = array(
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
        $styleSubtitulo = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 11,
                'name'  => 'Arial',
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );



        $this->docexcel->createSheet();
        $this->docexcel->getActiveSheet()->setTitle('Nro. Tramites');
        $this->docexcel->setActiveSheetIndex(0);

        $this->docexcel->getActiveSheet()->setCellValue('A1','EMPRESA: ENDE TRANSMISION S.A.');
        $this->docexcel->getActiveSheet()->getStyle('A1:D1')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->mergeCells('A1:D1');
        $this->docexcel->getActiveSheet()->setCellValue('E2','ESTADO '.$datos[0]['nombre_auxiliar'].' ('.$datos[0]['nombre_auxiliar'].')');
        $this->docexcel->getActiveSheet()->getStyle('E2:I2')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->mergeCells('E2:I2');

        $this->docexcel->getActiveSheet()->setCellValue('E3','Desde: '.date_format(date_create($this->objParam->getParametro('desde')),'d/m/y').' Hasta:'.date_format(date_create($this->objParam->getParametro('hasta')),'d/m/y'));
        $this->docexcel->getActiveSheet()->getStyle('E2:I3')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->mergeCells('E3:I3');

        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(18);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(18);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(18);
        $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(18);
        $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(18);
        $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(200);
        $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(50);  //#83

        $this->docexcel->getActiveSheet()->setCellValue('A5','Num. Comprobamte');
        $this->docexcel->getActiveSheet()->setCellValue('B5','Cuenta');
        $this->docexcel->getActiveSheet()->setCellValue('C5','Auxiliar');
        $this->docexcel->getActiveSheet()->setCellValue('D5','Num Tramite.');
        $this->docexcel->getActiveSheet()->setCellValue('E5','Fecha');
        $this->docexcel->getActiveSheet()->setCellValue('F5','Debe MB');
        $this->docexcel->getActiveSheet()->setCellValue('G5','Haber MB');
        $this->docexcel->getActiveSheet()->setCellValue('H5','Saldo MB');
        $this->docexcel->getActiveSheet()->setCellValue('I5','Debe MT');
        $this->docexcel->getActiveSheet()->setCellValue('J5','Haber MT');
        $this->docexcel->getActiveSheet()->setCellValue('K5','Glosa');
        $this->docexcel->getActiveSheet()->setCellValue('L5','Beneficiario'); //#83
        $this->docexcel->getActiveSheet()->getStyle('A5:L5')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A5:L5')->applyFromArray($styleSubtitulo);
    }

    function generarDatos(){

        $this->imprimeCabecera();
        $datos = $this->objParam->getParametro('datos');
        $fila = 6;

        $negativo  = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => 'FF3333'
                )
            ));


        $total= array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial'
            ),

            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'D0ECE7'
                )
            )
        );
        $border = array(
            'borders' => array(
                'vertical' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );
        $total2= array(
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
        $centrar = array(

            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );
        $importe_debe_mb = 0;
        $importe_haber_mb = 0;
        $importe_debe_mt = 0;
        $importe_haber_mt = 0;

        foreach ($datos as $value){
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['id_int_comprobante']);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:A$fila")->applyFromArray($centrar);
            if($value['tipo'] != 'B') {
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['nro_cuenta'].' ('.$value['nombre_cuenta'].')');
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['codigo_auxiliar'].' ('.$value['nombre_auxiliar'].')');
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['nro_tramite']);
            }
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila,date_format(date_create($value['fecha']),'d/m/y') );
            $this->docexcel->getActiveSheet()->getStyle("D$fila:E$fila")->applyFromArray($centrar);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['importe_debe_mb']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['importe_haber_mb']);
            if($value['tipo'] == 'B') {
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['saldo_mb']);
                if ($value['saldo_mb'] < 0) {
                    $this->docexcel->getActiveSheet()->getStyle("H$fila:H$fila")->applyFromArray($negativo);
                }
            }
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['importe_debe_mt']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['importe_haber_mt']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['glosa1']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['beneficiario']); //#83
            $this->docexcel->getActiveSheet()->getStyle("F$fila:J$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
            if($value['tipo'] == 'B') {
                $this->docexcel->getActiveSheet()->getStyle("F$fila:J$fila")->applyFromArray($total);
                $importe_debe_mb = $importe_debe_mb + $value['importe_debe_mb'];
                $importe_haber_mb = $importe_haber_mb + $value['importe_haber_mb'];

                $importe_debe_mt = $importe_debe_mt + $value['importe_debe_mt'];
                $importe_haber_mt = $importe_haber_mt + $value['importe_haber_mt'];
            }
            $this->docexcel->getActiveSheet()->getStyle("A$fila:L$fila")->applyFromArray($border);
            $fill = $fila + 1;
            $this->docexcel->getActiveSheet()->getStyle("F$fill:K$fill")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
            $fila ++;
            $this->fila_aux = $fila;
        }
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$this->fila_aux,'TOTAL');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$this->fila_aux,$importe_debe_mb);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6,$this->fila_aux,$importe_haber_mb);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7,$this->fila_aux, $importe_debe_mb - $importe_haber_mb);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8,$this->fila_aux,$importe_debe_mt);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9,$this->fila_aux,$importe_haber_mt);
        $this->docexcel->getActiveSheet()->getStyle("A$this->fila_aux:L$this->fila_aux")->applyFromArray($total2);

    }
    function imprimeSubtitulo($fila, $valor) {
        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial'
            ));

        $this->docexcel->getActiveSheet()->getStyle("A$fila:A$fila")->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $valor);
    }
    function generarReporte(){
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);
    }

}
?>