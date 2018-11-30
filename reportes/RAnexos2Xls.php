<?php
// Extend the TCPDF class to create custom MultiRow
class RAnexos2Xls
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

    function imprimeCabecera() {

        $this->docexcel->createSheet();
        $this->docexcel->getActiveSheet()->setTitle('Anexos 2');
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
        $this->docexcel->getActiveSheet()->setCellValue('A4','NFORMACION SOBRE LA DETERMINACION DEL CREDITO FISCAL IVA DECLARADO');
        $this->docexcel->getActiveSheet()->setCellValue('A5','(EXPRESADO EN BOLIVIANOS)');
        $this->docexcel->getActiveSheet()->setCellValue('O1','ANEXO 2');
        $this->docexcel->getActiveSheet()->getStyle('A1:O5')->applyFromArray($titulossubcabezera);

        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(12);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(25);

        $this->docexcel->getActiveSheet()->setCellValue('A8','2001');
        $this->docexcel->getActiveSheet()->setCellValue('B8','2002');
        $this->docexcel->getActiveSheet()->setCellValue('C8','2003');
        $this->docexcel->getActiveSheet()->setCellValue('D8','2004');
        $this->docexcel->getActiveSheet()->setCellValue('E8','2005');
        $this->docexcel->getActiveSheet()->setCellValue('F8','2006');
        $this->docexcel->getActiveSheet()->setCellValue('G8','2007');
        $this->docexcel->getActiveSheet()->setCellValue('H8','2008');
        $this->docexcel->getActiveSheet()->setCellValue('I8','2009');
        $this->docexcel->getActiveSheet()->setCellValue('J8','2010');
        $this->docexcel->getActiveSheet()->setCellValue('K8','2011');
        $this->docexcel->getActiveSheet()->setCellValue('L8','2012');
        $this->docexcel->getActiveSheet()->setCellValue('M8','2013');
        $this->docexcel->getActiveSheet()->setCellValue('N8','2014');
        $this->docexcel->getActiveSheet()->setCellValue('O8','2015');
        $this->docexcel->getActiveSheet()->getStyle('A8:O8')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A8:O8')->applyFromArray($styleTitulos3);
        $this->docexcel->getActiveSheet()->setCellValue('A9','Meses');
        $this->docexcel->getActiveSheet()->setCellValue('B9','Saldo del Crédito Fiscal al Inicio de Cada Mes Según Mayores');
        $this->docexcel->getActiveSheet()->setCellValue('C9','Mantenimiento de Valor');
        $this->docexcel->getActiveSheet()->setCellValue('D9','Incremento del Crédito Fiscal del Periodo Según Mayores');
        $this->docexcel->getActiveSheet()->setCellValue('E9','Incremento del Crédito Fiscal Devoluciones Recibidas y Descuentos Otorgados Según Mayores');
        $this->docexcel->getActiveSheet()->setCellValue('F9','CEDEIM');
        $this->docexcel->getActiveSheet()->setCellValue('G9','Restitucion de Crédito Fiscal');
        $this->docexcel->getActiveSheet()->setCellValue('H9','Reversiones y/o Ajustes Contables');
        $this->docexcel->getActiveSheet()->setCellValue('I9','Debito Fiscal Compensado en el Periodo Según Mayores');
        $this->docexcel->getActiveSheet()->setCellValue('J9','Saldo al Cierre del Mes Según Estados Financieros');
        $this->docexcel->getActiveSheet()->setCellValue('K9','Credito Fiscal por Facturas Correspondientes a Meses Anteriores');
        $this->docexcel->getActiveSheet()->setCellValue('L9','Crédito Fiscal por Facturas Registradas en Meses Posteriores');
        $this->docexcel->getActiveSheet()->setCellValue('M9','Saldo Ajustado de Crédito Fiscal del Periodo');
        $this->docexcel->getActiveSheet()->setCellValue('N9','Crédito Fiscal Declarado del Periodo Según Form. 200 ó 210');
        $this->docexcel->getActiveSheet()->setCellValue('O9','Diferencias (1)');
        $this->docexcel->getActiveSheet()->getStyle('A9:O9')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A9:O9')->applyFromArray($styleTitulos3);
        //
        $this->docexcel->getActiveSheet()->setCellValue('B10','A');
        $this->docexcel->getActiveSheet()->setCellValue('C10','B');
        $this->docexcel->getActiveSheet()->setCellValue('D10','C');
        $this->docexcel->getActiveSheet()->setCellValue('E10','D');
        $this->docexcel->getActiveSheet()->setCellValue('F10','E');
        $this->docexcel->getActiveSheet()->setCellValue('G10','F');
        $this->docexcel->getActiveSheet()->setCellValue('H10','G');
        $this->docexcel->getActiveSheet()->setCellValue('I10','H');
        $this->docexcel->getActiveSheet()->setCellValue('J10','I = A+B+C+D-E+F-G-H');
        $this->docexcel->getActiveSheet()->setCellValue('K10','J');
        $this->docexcel->getActiveSheet()->setCellValue('L10','K');
        $this->docexcel->getActiveSheet()->setCellValue('M10','L=C+D-J+K');
        $this->docexcel->getActiveSheet()->setCellValue('N10','M');
        $this->docexcel->getActiveSheet()->setCellValue('O10','N=L-M');
        $this->docexcel->getActiveSheet()->getStyle('A10:O10')->applyFromArray($centar);
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
        $fila = 11;
        $datos = $this->objParam->getParametro('datos');

        $mes_literal = array('ENERO','FEBRERO','MARZO','ABRIL','MAYO','JUNIO','JULIO','AGOSTO','SEPTIEMBRE','OCTUBRE','NOVIEMBRE','DICIEMBRE');
        foreach ($datos as $value){


            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $mes_literal[$value['periodo'] - 1]);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['monto_a']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['monto_b']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['monto_c']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['monto_d']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['monto_e']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['monto_f']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['monto_g']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['monto_h']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, '=B'.$fila.'+C'.$fila.'+D'.$fila.'+E'.$fila.'+F'.$fila.'+G'.$fila.'-H'.$fila.'-I'.$fila);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['monto_j']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['monto_k']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, '=(D'.$fila.'+E'.$fila.'-K'.$fila.'+L'.$fila.')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, $value['monto_m']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, '=M'.$fila.'-N'.$fila);

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila+1,'TOTAL');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$fila+1,'=SUM(D9:D'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$fila+1,'=SUM(E9:E'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fila+1,'=SUM(F9:F'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6,$fila+1,'=SUM(G9:G'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7,$fila+1,'=SUM(H9:H'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8,$fila+1,'=SUM(I9:I'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9,$fila+1,'=SUM(J9:J'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10,$fila+1,'=SUM(K9:K'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11,$fila+1,'=SUM(L9:L'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12,$fila+1,'=SUM(M9:M'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13,$fila+1,'=SUM(N9:N'.($fila).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14,$fila+1,'=SUM(O9:O'.($fila).')');
            $this->docexcel->getActiveSheet()->getStyle("B$fila:O$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:P$fila")->applyFromArray($border);
            $fila++;
            $this->fila_aux = $fila;
        }

        $fill = $this->fila_aux ;
        $this->docexcel->getActiveSheet()->getStyle("B$fill:O$fill")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
        $this->docexcel->getActiveSheet()->getStyle("A$fill:O$fill")->applyFromArray($total);

    }
    public function bindValue(PHPExcel_Cell $cell, $value = null)
    {
        // sanitize UTF-8 strings
        if (is_string($value)) {
            $value = PHPExcel_Shared_String::SanitizeUTF8($value);
        }

        // Implement your own override logic
        if (is_string($value) && $value[0] == '0') {
            $cell->setValueExplicit($value, PHPExcel_Cell_DataType::TYPE_STRING);
            return true;
        }

        // Not bound yet? Use default value parent...
        return parent::bindValue($cell, $value);
    }
    function generarReporte(){
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);

    }

}
?>