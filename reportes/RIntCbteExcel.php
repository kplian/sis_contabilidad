<?php
/**
 *@package pXP
 *@file RIntCbteExcel.php
 *@author  MMV
 *@date 08/01/2020
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
ISSUE     FORK          FECHA:		       AUTOR                 DESCRIPCION
#87		  ETR		    08/01/2020	        MMV 		         Reporte Cbte formato Excel
 */
// Extend the TCPDF class to create custom MultiRow
class RIntCbteExcel{
    private $docexcel;
    private $objWriter;
    public $fila_aux = 0;
    private $equivalencias=array();
    private $objParam;
    public  $url_archivo;
    public  $aux;
    private $cabecera;
    private $detalleCbte;

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
    function datosHeader ($dataSource) {
        $this->cabecera = $dataSource->getParameter('cabecera');
        $this->detalleCbte = $dataSource->getParameter('detalleCbte');
    }
    function imprimeCabecera() {
        $this->docexcel->createSheet();
        $this->docexcel->getActiveSheet()->setTitle('Cbte');
        $this->docexcel->setActiveSheetIndex(0);

        $objDrawing = new PHPExcel_Worksheet_Drawing();
        $objDrawing->setName('test_img');
        $objDrawing->setDescription('test_img');
        $objDrawing->setPath(dirname(__FILE__) . '/../../pxp/lib' . $_SESSION['_DIR_LOGO']);
        $objDrawing->setCoordinates('A1'); //setOffsetX works properly
        $objDrawing->setOffsetX(5);
        $objDrawing->setOffsetY(5); //set width, height
        $objDrawing->setWidth(250);
        $objDrawing->setHeight(87);
        $objDrawing->setWorksheet($this->docexcel->getActiveSheet());

        $titulossubcabezera = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 15,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
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
        $this->docexcel->getActiveSheet()->mergeCells('A1:A4');

        $newDate = date("d/m/Y", strtotime( $this->cabecera[0]['fecha']));
        $this->docexcel->getActiveSheet()->setCellValue('B1',$this->cabecera[0]['desc_clase_comprobante']);
        $this->docexcel->getActiveSheet()->mergeCells('B1:F4');
        $this->docexcel->getActiveSheet()->getStyle('B1:F4')->applyFromArray($titulossubcabezera);

        $this->docexcel->getActiveSheet()->setCellValue('G1','Depto: '.$this->cabecera[0]['codigo_depto']);
        $this->docexcel->getActiveSheet()->mergeCells('G1:H1');
        $this->docexcel->getActiveSheet()->setCellValue('G2','N°: '.$this->cabecera[0]['nro_cbte']);
        $this->docexcel->getActiveSheet()->mergeCells('G2:H2');
        $this->docexcel->getActiveSheet()->setCellValue('G3','Fecha: '.$newDate);
        $this->docexcel->getActiveSheet()->mergeCells('G3:H3');
        $this->docexcel->getActiveSheet()->setCellValue('G4','Fecha: '.$this->cabecera[0]['desc_moneda']);
        $this->docexcel->getActiveSheet()->mergeCells('G4:H4');

        $this->docexcel->getActiveSheet()->setCellValue('A5','Beneficiario: '.$this->cabecera[0]['beneficiario']);
        $this->docexcel->getActiveSheet()->setCellValue('G5','Nro Trámite: '.$this->cabecera[0]['nro_tramite']);
        $this->docexcel->getActiveSheet()->mergeCells('G5:H5');
        $this->docexcel->getActiveSheet()->setCellValue('A6','Glosa: '.$this->cabecera[0]['glosa1']);

        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(60);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(20);
        //Primer
        $this->docexcel->getActiveSheet()->setCellValue('A8','DETALLE');
        $this->docexcel->getActiveSheet()->setCellValue('B8','BS');
        $this->docexcel->getActiveSheet()->mergeCells('B8:D8');
        $this->docexcel->getActiveSheet()->setCellValue('E8','$us');
        $this->docexcel->getActiveSheet()->mergeCells('E8:F8');
        $this->docexcel->getActiveSheet()->setCellValue('G8','UFV');
        $this->docexcel->getActiveSheet()->mergeCells('G8:H8');
        $this->docexcel->getActiveSheet()->getStyle('A8:H8')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A8:H8')->applyFromArray($styleTitulos3);
        //Segundo
        $this->docexcel->getActiveSheet()->mergeCells('A8:A9');
        $this->docexcel->getActiveSheet()->setCellValue('B9','Ejecución');
        $this->docexcel->getActiveSheet()->setCellValue('C9','Debe');
        $this->docexcel->getActiveSheet()->setCellValue('D9','Haber');
        $this->docexcel->getActiveSheet()->setCellValue('E9','Debe');
        $this->docexcel->getActiveSheet()->setCellValue('F9','Haber');
        $this->docexcel->getActiveSheet()->setCellValue('G9','Debe');
        $this->docexcel->getActiveSheet()->setCellValue('H9','Haber');
        $this->docexcel->getActiveSheet()->getStyle('A9:H9')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A9:H9')->applyFromArray($styleTitulos3);
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
        $fila = 10;
        $fila_suma = 0;
        $glosa = "";
        $importe = 0;
        foreach($this->detalleCbte as $key=>$val){
            $glosa = "CC.: ".$val['cc']."\n";
            if  ($val['codigo_partida']!=''){
                $glosa = $glosa."PTDA.: ". $val['codigo_partida']." - ".$val['nombre_partida']."\n";
            }
            $glosa = $glosa."CTA.: ".$val['nro_cuenta']." - ".$val['nombre_cuenta']."\n";
            if  ($val['codigo_auxiliar']!=''){
                $glosa = $glosa."AUX.: ".$val['codigo_auxiliar']." - ".$val['nombre_auxiliar']."\n";
            }
            if  ($val['desc_orden']!=''){
                $glosa = $glosa." ".trim($val['glosa'])."\n";
            }
            if  ($this->cabecera[0]['sw_tipo_cambio']=='si'){
                $glosa = $glosa."TIPO CAMBIO.: ".number_format($val['tipo_cambio'], 2, '.', ',');
            }
            if ($val['importe_gasto']>0){
                $importe = $val['importe_gasto'];
            }else{
                $importe = $val['importe_recurso'];
            }
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila,$glosa);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$fila,$importe);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fila,$val['importe_debe']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$fila,$val['importe_haber']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$fila,$val['importe_debe_mt']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fila,$val['importe_haber_mt']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6,$fila,$val['importe_debe_ma']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7,$fila,$val['importe_haber_ma']);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:A$fila")->getAlignment()->setWrapText(true);
            $this->docexcel->getActiveSheet()->getStyle("B$fila:H$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:I$fila")->applyFromArray($border);
            $fila++;
            $fila_suma = $fila;
        }
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila_suma,'=SUM(B10:B'.($fila_suma-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila_suma,'=SUM(C10:C'.($fila_suma-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila_suma,'=SUM(D10:D'.($fila_suma-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila_suma,'=SUM(E10:E'.($fila_suma-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila_suma,'=SUM(F10:F'.($fila_suma-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila_suma,'=SUM(G10:G'.($fila_suma-1).')');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila_suma,'=SUM(H10:H'.($fila_suma-1).')');
        $this->docexcel->getActiveSheet()->getStyle("B$fila_suma:H$fila_suma")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
        $this->docexcel->getActiveSheet()->getStyle("A$fila_suma:H$fila_suma")->applyFromArray($total);

    }
    function imprimeSubtitulo($fila, $valor) {
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

        $this->docexcel->getActiveSheet()->getStyle("A$fila:A$fila")->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->mergeCells("A$fila:F$fila");
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $valor);
    }

    function generarReporte(){
        $this->generarDatos();
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);

    }

}
?>

