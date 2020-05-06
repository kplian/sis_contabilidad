<?php
/**
 *@package pXP
 *@file RReporteRegistrosVentaCC
 *@author  (Miguel Mamani)
 *@date 19/12/2108
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * HISTORIAL DE MODIFICACIONES:
 * ISSUE 		   FECHA   			 AUTOR				 DESCRIPCION:
 * #113         29/04/2020		     MMV	             Reporte Registro Ventas CC
 */
class RReporteRegistrosVentaCC{
    private $docexcel;
    private $objWriter;
    private $equivalencias=array();
    private $objParam;
    public  $url_archivo;
    function __construct(CTParametro $objParam){
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
        $this->docexcel->getActiveSheet()->setTitle('Registros Ventas');
        $this->docexcel->setActiveSheetIndex(0);

        $styleTitulos1 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 14,
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
        //modificacionw
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'Registro de Ventas Centro Costo' );
        $this->docexcel->getActiveSheet()->getStyle('A2:W2')->applyFromArray($styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A2:W2');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13,3,'Gestion: '.$this->objParam->getParametro('gestion').'     Periodo: '.$this->objParam->getParametro('periodo'));
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15,3,'Depto: '.$this->objParam->getParametro('depto').'     Plantilla: '.$this->objParam->getParametro('plantilla'));

        $this->docexcel->getActiveSheet()->getStyle('A3:W3')->applyFromArray($styleTitulos3);

        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(13);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(15);

        $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('R')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('S')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('T')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('U')->setWidth(15);

        $this->docexcel->getActiveSheet()->getColumnDimension('V')->setWidth(35);
        $this->docexcel->getActiveSheet()->getColumnDimension('W')->setWidth(55);

        $this->docexcel->getActiveSheet()->getStyle('A5:W5')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A5:W5')->applyFromArray($styleTitulos2);

        $this->docexcel->getActiveSheet()->setCellValue('A5','ID');
        $this->docexcel->getActiveSheet()->setCellValue('B5','Revisado');
        $this->docexcel->getActiveSheet()->setCellValue('C5','NIT/CI');
        $this->docexcel->getActiveSheet()->setCellValue('D5','Nro Doc');
        $this->docexcel->getActiveSheet()->setCellValue('E5','Autorizacion');
        $this->docexcel->getActiveSheet()->setCellValue('F5','Fecha');
        $this->docexcel->getActiveSheet()->setCellValue('G5','Razon Social');
        $this->docexcel->getActiveSheet()->setCellValue('H5','Codigo Control');
        $this->docexcel->getActiveSheet()->setCellValue('I5','Monto');
        $this->docexcel->getActiveSheet()->setCellValue('J5','Exento');
        $this->docexcel->getActiveSheet()->setCellValue('K5','Descuento');
        $this->docexcel->getActiveSheet()->setCellValue('L5','Importe c/d');
        $this->docexcel->getActiveSheet()->setCellValue('M5','Neto');
        $this->docexcel->getActiveSheet()->setCellValue('N5','IVA');

        $this->docexcel->getActiveSheet()->setCellValue('O5','Tipo Documento');
        $this->docexcel->getActiveSheet()->setCellValue('P5','Estado');
        $this->docexcel->getActiveSheet()->setCellValue('Q5','Cbte');
        $this->docexcel->getActiveSheet()->setCellValue('R5','Id Int Comprobante');
        $this->docexcel->getActiveSheet()->setCellValue('S5','Nro Tramite');
        $this->docexcel->getActiveSheet()->setCellValue('T5','Estado Cbte');
        $this->docexcel->getActiveSheet()->setCellValue('U5','Moneda');
        $this->docexcel->getActiveSheet()->setCellValue('V5','Observaciones');
        $this->docexcel->getActiveSheet()->setCellValue('W5','Centro Costo');
    }
    function generarDatos(){
        $this->imprimeCabecera();
        $datos = $this->objParam->getParametro('datos');
        $fila = 6;
        $centro_costo = '';
        $depto= '';

        $centar = array('alignment' => array(
            'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
            'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
        )
        );
        $border = array(
            'borders' => array(
                'vertical' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );
        foreach ($datos as $value){
            if ($this->objParam->getParametro('agrupar') == 'centro_costo'){
                if ($value['codigo_cc'] != $centro_costo) {
                    $this->imprimeSubtitulo($fila,$value['codigo_cc']);
                    $centro_costo = $value['codigo_cc'];
                    $fila++;
                }
            }
            if ($this->objParam->getParametro('agrupar') == 'depto'){
                if ($value['desc_depto'] != $depto) {
                    $this->imprimeSubtitulo($fila,$value['desc_depto']);
                    $depto = $value['desc_depto'];
                    $fila++;
                }
            }
            if ($this->objParam->getParametro('agrupar') == 'depto_cc'){
                if ($value['desc_depto'] != $depto) {
                    $this->imprimeSubtitulo($fila,$value['desc_depto']);
                    $depto = $value['desc_depto'];
                    $fila++;
                }
                if ($value['codigo_cc'] != $centro_costo && $value['codigo_cc'] != $value['desc_depto']){
                    $this->imprimeSubtituloDep($fila,$value['codigo_cc']);
                    $centro_costo = $value['codigo_cc'];
                    $fila++;
                }
            }

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['id_doc_compra_venta']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['revisado']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['nit']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['nro_documento']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['nro_autorizacion']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['fecha']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['razon_social']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['codigo_control']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['importe_doc']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['importe_excento']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['importe_descuento']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['importe_neto']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, $value['importe_aux_neto']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, $value['importe_iva']);


            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, $value['desc_plantilla']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15, $fila, $value['desc_tipo_doc_compra_venta']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16, $fila, $value['desc_comprobante']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(17, $fila, $value['id_int_comprobante']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(18, $fila, $value['nro_tramite']);

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(19, $fila, $value['estado_cbte']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(20, $fila, $value['desc_moneda']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(21, $fila, $value['obs']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(22, $fila, $value['codigo_cc']);

            $this->docexcel->getActiveSheet()->getStyle("E$fila:E$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER);
            $this->docexcel->getActiveSheet()->getStyle("I$fila:N$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
            $this->docexcel->getActiveSheet()->getStyle("B$fila:B$fila")->applyFromArray($centar);
            $this->docexcel->getActiveSheet()->getStyle("F$fila:F$fila")->applyFromArray($centar);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:X$fila")->applyFromArray($border);
            $fila ++;
        }
    }

    function imprimeSubtitulo($fila, $valor) {
        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 11,
                'name'  => 'Arial'
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));

        $this->docexcel->getActiveSheet()->getStyle("A$fila:W$fila")->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->mergeCells("A$fila:W$fila");
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $valor);

    }
    function imprimeSubtituloDep($fila, $valor) {
        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial'
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));
        $this->docexcel->getActiveSheet()->getStyle("A$fila:W$fila")->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->mergeCells("A$fila:W$fila");
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $valor);

    }
    function generarReporte(){
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);

    }

}
?>

