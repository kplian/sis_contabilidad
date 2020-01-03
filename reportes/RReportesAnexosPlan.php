<?php
// Extend the TCPDF class to create custom MultiRow
class RReportesAnexosPlan{
    private $docexcel;
    private $objWriter;
    private $equivalencias=array();
    private $objParam;
    public  $url_archivo;
    private $titulos = array();
    private $columna = array();
    private $fila_total = 0;
    private $columna_total = 0;
    var $resulta;
    var $desgrosa;
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
    function datosHeader ( $resultado, $desgrosa) {
       $this->resulta = $resultado;
       $this->desgrosa = $desgrosa;
    }

    function imprimeCabecera() {
        //Cabecera
        $this->docexcel->createSheet();
        $this->docexcel->getActiveSheet()->setTitle('Reporte');
        $this->docexcel->setActiveSheetIndex(0);
        $titulossubcabezera = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial'
            )
        );

        $styleTitulos2 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 8,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => '000000'
                )
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'FFFFFF'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ),
        );
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

        $datos =  $this->resulta;
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,$datos[0]['cabecera']);
        $this->docexcel->getActiveSheet()->getStyle('A2:C2')->applyFromArray($titulossubcabezera);
        $this->docexcel->getActiveSheet()->mergeCells('A2:C2');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,'GESTION '.$datos[0]['gestion']);
        $this->docexcel->getActiveSheet()->getStyle('A3:C3')->applyFromArray($titulossubcabezera);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,4,$datos[0]['titulo']);
        $this->docexcel->getActiveSheet()->getStyle('A4:O4')->applyFromArray($titulosCabezera);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16,4,$datos[0]['codigo']);
        $this->docexcel->getActiveSheet()->getStyle('A16:O16')->applyFromArray($titulosCabezera);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,5,'(EXPRESADO EN BOLIVIANO)');
        $this->docexcel->getActiveSheet()->getStyle('A5:O5')->applyFromArray($titulossubcabezera);
        $this->docexcel->getActiveSheet()->mergeCells('A1:C2');

       // var_dump($datos[0]['tipo_reporte']); exit;
        foreach ($datos as $value){
            if (!array_key_exists($value['numero'], $this->titulos) ||
                !array_key_exists($value['nombre'], $this->titulos[$value['numero']]) ||
                !array_key_exists($value['codigo_nombre'], $this->titulos[$value['numero']][$value['nombre']])) {
                $this->titulos[$value['numero']][$value['nombre']][$value['codigo_nombre']] = 1;
            } else {
                $this->titulos[$value['numero']][$value['nombre']][$value['codigo_nombre']]++;
            }
        }
        $columna = 0;
        foreach ($this->titulos as $value => $key){
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,7, $value);
            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[0] . "7:" . $this->equivalencias[$columna] . "7")->applyFromArray($styleTitulos3);
            foreach ($key as $vulue2 =>$key2){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,8, $vulue2);
                $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[0] . "8:" . $this->equivalencias[$columna] . "8")->getAlignment()->setWrapText(true);
                $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[0] . "8:" . $this->equivalencias[$columna] . "8")->applyFromArray($styleTitulos3);

            }
            foreach ($key2 as $vulue3 => $key3 ){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,9, $vulue3);
                $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[0] . "9:" . $this->equivalencias[$columna] . "9")->applyFromArray($styleTitulos2);
                $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[0] . "9:" . $this->equivalencias[$columna] . "9")->getAlignment()->setWrapText(true);
            }
            $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[$columna])->setWidth(17);
            $columna ++;
            $this->columna_total = $columna;
        }
        $max = count($this->titulos);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($max - 1 ,2,$this->objParam->getParametro('datos')[0]['glosa']);
        $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[0] . "2:" . $this->equivalencias[$max - 1] . "2")->applyFromArray($titulossubcabezera);
    }

    function generarDatos(){
        $this->imprimeCabecera();
        $border = array(
            'borders' => array(
                'vertical' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );
        $border2 = array(
            'borders' => array(
                'outline' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );
        $total= array(
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
        $fila = 10;
        $datos = $this->resulta;
        $nro = 0;
        $reinicar = '';
        $mes_literal = array('ENERO','FEBRERO','MARZO','ABRIL','MAYO','JUNIO','JULIO','AGOSTO','SEPTIEMBRE','OCTUBRE','NOVIEMBRE','DICIEMBRE');

      // var_dump($datos);exit;
        foreach ($datos as $value){

                if($value['ordenar'] != $reinicar ) {
                    $fila = 10;
                    $reinicar = $value['ordenar'];
                    $nro =  $value['ordenar'];
                }
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $mes_literal[$value['periodo'] - 1]);
                $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(12);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($nro - 1, $fila,$value['importe']  /*round(abs($value['importe']))*/);
                $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[0] . "$fila:" . $this->equivalencias[$nro] . "$fila")->applyFromArray($border);
                $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[1] . "$fila:" . $this->equivalencias[$nro] . "$fila")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
                $fila++;
                $this->fila_total = $fila;

        }
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $this->fila_total, 'TOTAL');
        $fila_final = $this->fila_total - 1;

        for ($i = 1; $i < $this->columna_total ; $i++){
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($i,$this->fila_total,"=SUM(".$this->equivalencias[$i]."10:".$this->equivalencias[$i]."$fila_final)");
            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$i]."$this->fila_total:".$this->equivalencias[$i]."$this->fila_total")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$i - 1]."$this->fila_total:".$this->equivalencias[$i]."$this->fila_total")->applyFromArray($total);
        }
        $desgrosar = $this->fila_total + 4;
        $filaDes =  $desgrosar + 1 ;
        $suma = $filaDes + 1;
        $col = 2;
        $titulo = '';
        if (count($this->desgrosa) > 0){
            foreach ($this->desgrosa as $value){
                if($value['codigo'] != $titulo ) {
                    if ($titulo != '') {
                        $col = $col + 5;
                    }
                    $titulo = $value['codigo'];
                    $filaDes = $desgrosar + 2 ;
                    $this->imprimeSubtitulo($col,$desgrosar,$titulo);
                }
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($col,$filaDes, $value['nro_cuenta']);
                $this->docexcel->getActiveSheet()->mergeCells($this->equivalencias[$col]."$filaDes:".$this->equivalencias[$col + 1]."$filaDes");
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($col + 2,$filaDes, $value['importe']);
                $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$col + 2]."$filaDes:".$this->equivalencias[$col + 2]."$filaDes")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
                $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$col] . "$filaDes:" . $this->equivalencias[$col + 2] . "$filaDes")->applyFromArray($border2);
                $filita = $filaDes + 1;
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($col, $filita, 'Total');
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($col + 2, $filita, "=SUM(".$this->equivalencias[$col + 2]."$suma:".$this->equivalencias[$col + 2]."$filaDes)");
                $this->docexcel->getActiveSheet()->mergeCells($this->equivalencias[$col]."$filita:".$this->equivalencias[$col + 1]."$filita");
                $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$col + 2]."$filita:".$this->equivalencias[$col + 2]."$filita")->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED1);
                $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$col] . "$filita:" . $this->equivalencias[$col + 2] . "$filita")->applyFromArray($border2);
                $filaDes++;
            }

        }
    }
    function imprimeSubtitulo($col,$fila,$valor) {
        $columna = $col ;
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
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fila,$valor);
        $this->docexcel->getActiveSheet()->mergeCells($this->equivalencias[$columna]."$fila:".$this->equivalencias[$columna + 2]."$fila");
        $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna]."$fila:".$this->equivalencias[$columna + 2]."$fila")->applyFromArray($styleTitulos3);
        $fill = $fila + 1;
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna,$fill, 'Glosa');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna + 2,$fill, 'Importe');
        $this->docexcel->getActiveSheet()->mergeCells($this->equivalencias[$columna]."$fill:".$this->equivalencias[$columna + 1]."$fill");
         $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna]."$fill:".$this->equivalencias[$columna + 2]."$fill")->applyFromArray($styleTitulos3);


    }
    function generarColumna($valor){
        $columna = 0;
        $this->columna=array( 1=>'A',2=>'B',3=>'C',4=>'D',5=>'E',6=>'F',7=>'G',8=>'H',9=>'I',
            10=>'J',11=>'K',12=>'L',13=>'M',14=>'N',15=>'O',16=>'P',17=>'Q',18=>'R',
            19=>'S',20=>'T',21=>'U',22=>'V',23=>'W',24=>'X',25=>'Y',26=>'Z');
        $contador = 1;
        while ($contador < count($this->columna)) {
            $this->columna[$contador];

            if($this->columna[$contador] == $valor){
                $columna = $contador;
            }
            $contador ++;
        }
        return $columna;
    }
    function generarReporte(){
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);
    }

}
?>