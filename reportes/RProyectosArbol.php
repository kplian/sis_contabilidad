<?php
/**
**************************************************************************
ISSUE  SIS       EMPRESA       FECHA        AUTOR           DESCRIPCION
#2     CONTA     ETR           19/12/2108   Miguel Mamani	reporte proyectos excel
#10    CONTA     ETR           02/01/2019   Miguel Mamani   Nuevo parámetro tipo de moneda para el reporte detalle Auxiliares por Cuenta
#154    CONTA     ETR           01/08/2019   RCM             Corrección por actualización de PHP 7. Se cambia el string Arial por cadena 'Arial'
**************************************************************************
*/
class RProyectosArbol
{
    private $docexcel;
    private $objWriter;
    private $equivalencias=array();
    private $grupos=array();
    private $objParam;
    public  $url_archivo;
    private $ulitmoNivelGrupo = 0;

    function __construct(CTParametro $objParam){
        $this->objParam = $objParam;
        $this->url_archivo = "../../../reportes_generados/".$this->objParam->getParametro('nombre_archivo');
        //ini_set('memory_limit','512M');
        set_time_limit(400);
        $cacheMethod = PHPExcel_CachedObjectStorageFactory:: cache_to_phpTemp;
        $cacheSettings = array('memoryCacheSize'  => '10MB');
        PHPExcel_Settings::setCacheStorageMethod($cacheMethod, $cacheSettings);
        PHPExcel_Shared_Font::setAutoSizeMethod(PHPExcel_Shared_Font::AUTOSIZE_METHOD_EXACT);


        $this->docexcel = new PHPExcel();
        $this->docexcel->getProperties()->setCreator("PXP")
            ->setLastModifiedBy("PXP")
            ->setTitle($this->objParam->getParametro('titulo_archivo'))
            ->setSubject($this->objParam->getParametro('titulo_archivo'))
            ->setDescription('Reporte "'.$this->objParam->getParametro('titulo_archivo').'", generado por el framework PXP')
            ->setKeywords("office 2007 openxml php")
            ->setCategory("Report File");
        $this->docexcel->setActiveSheetIndex(0);
        $this->docexcel->getActiveSheet()->setTitle($this->objParam->getParametro('titulo_archivo'));
        $this->equivalencias=array(0=>'A',1=>'B',2=>'C',3=>'D',4=>'E',5=>'F',6=>'G',7=>'H',8=>'I',
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


    function imprimirTitulo($sheet){
        //#10
        $Tc = 'Tipo Costo: ('.$this->objParam->getParametro('tipo_costo').')';
        if($this->objParam->getParametro('cuenta') != ''){
            $cuenta = ' Cuenta: ('.$this->objParam->getParametro('cuenta').')';
        }else{
            $cuenta = '';
        }
        if($this->objParam->getParametro('centro_costo') != ''){
            $Cc = ' Centro Costo: ('.$this->objParam->getParametro('centro_costo').')';
        }else{
            $Cc = '';
        }
        //#10

        $titulo = 'Árbol  '.$Tc.$cuenta.$Cc;
        $fechas = 'Del '.$this->objParam->getParametro('desde').' al '.$this->objParam->getParametro('hasta');
        $moneda = '(Expresado en '.$this->objParam->getParametro('moneda').')';  //#10
        //TODO imprimir titulo
        $sheet->getColumnDimension($this->equivalencias[0])->setWidth(2);
        $sheet->getColumnDimension($this->equivalencias[1])->setWidth(2);
        $sheet->getColumnDimension($this->equivalencias[2])->setWidth(2);
        $sheet->getColumnDimension($this->equivalencias[3])->setWidth(2);
        $sheet->getColumnDimension($this->equivalencias[4])->setWidth(2);
        $sheet->getColumnDimension($this->equivalencias[5])->setWidth(2);
        $sheet->getColumnDimension($this->equivalencias[6])->setWidth(2);
        $sheet->getColumnDimension($this->equivalencias[7])->setWidth(2);
        $sheet->getColumnDimension($this->equivalencias[8])->setWidth(2);
        $sheet->getColumnDimension($this->equivalencias[9])->setWidth(2);
        $sheet->getColumnDimension($this->equivalencias[10])->setWidth(45);
        $sheet->getColumnDimension($this->equivalencias[11])->setWidth(45);
        $sheet->getColumnDimension($this->equivalencias[12])->setWidth(45);

        $sheet->getStyle('A2')->getFont()->applyFromArray(array('bold'=>true,
            'size'=>12,
            'name'=>'Arial')); //#154

        $sheet->getStyle('A2')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
        $sheet->setCellValueByColumnAndRow(0,2,$titulo);
        $sheet->mergeCells('A2:T2');

        //FECHAS
        $sheet->getStyle('A3')->getFont()->applyFromArray(array(
            'bold'=>true,
            'size'=>10,
            'name'=>'Arial')); //#154

        $sheet->getStyle('A3')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
        $sheet->setCellValueByColumnAndRow(0,3,$fechas);
        $sheet->mergeCells('A3:T3');
        $sheet->getStyle('A4')->getFont()->applyFromArray(array(
            'bold'=>true,
            'size'=>10,
            'name'=>'Arial')); //#154

        $sheet->getStyle('A4')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
        $sheet->setCellValueByColumnAndRow(0,4,$moneda);
        $sheet->mergeCells('A4:T4');

    }
    function imprimirCabecera($sheet, $fila){

        $estilo = array('bold'=>true,
            'italic'=>false,
            'underline'=>false,
            'size'=>12);

        $sheet->getStyle(($this->equivalencias[1]).$fila)->getFont()->applyFromArray($estilo);


        $sheet->getStyle(($this->equivalencias[1]).$fila)->getAlignment()->setHorizontal('center');
        $sheet->setCellValueByColumnAndRow(1,$fila,'Codigo/Descripcion');
        $sheet->mergeCells(($this->equivalencias[1]).$fila.':k'.$fila);
        $sheet->getStyle(($this->equivalencias[1]).$fila)->getAlignment()->setWrapText(true);

        $sheet->setCellValueByColumnAndRow(11,$fila,'Monto');
        $sheet->getStyle(($this->equivalencias[11]).$fila)->getAlignment()->setHorizontal('center');
        $sheet->getStyle(($this->equivalencias[11]).$fila)->getFont()->applyFromArray($estilo);

        $sheet->setCellValueByColumnAndRow(12,$fila,'Monto Formulado');
        $sheet->getStyle(($this->equivalencias[12]).$fila)->getAlignment()->setHorizontal('center');
        $sheet->getStyle(($this->equivalencias[12]).$fila)->getFont()->applyFromArray($estilo);
    }


    function imprimirDatos(){
        $datos = $this->objParam->getParametro('datos');
        $sheet = $this->docexcel->getActiveSheet();
        $this->imprimirTitulo($sheet);
        $this->imprimirCabecera($sheet, 5);
        $fila = 6;

        foreach($datos as $val) {
            $fila = $this->imprimirLinea($sheet,$fila, $val);
            $this->agregarMes($sheet,$fila-1,$val);

        }
    }
    function imprimirLinea($sheet, $fila, $val){
        $underline = false;
        $italic = false;
        $texto = $val['codigo_tcc'];
        $sw_movimiento = $val['sw_tipo'];

        if($sw_movimiento == 'titulo'){
            $negrilla = true;
        }else{
            $negrilla = false;
        }

        $sheet->getStyle(($this->equivalencias[$val["nivel"] - 1]).$fila)->getFont()->applyFromArray(array(
            'bold'=>$negrilla,
            'italic'=>$italic,
            'underline'=>$underline,
            'size'=>10));

        //  $sheet->getStyle(($this->equivalencias[$val["nivel"] - 1]).$fila)->getAlignment()->setHorizontal($posicion);
        $sheet->setCellValueByColumnAndRow($val["nivel"] - 1,$fila,$texto);
        $sheet->mergeCells(($this->equivalencias[$val["nivel"] - 1]).$fila.':k'.$fila);
        $sheet->getStyle(($this->equivalencias[$val["nivel"] - 1]).$fila)->getAlignment()->setWrapText(true);
        $this->docexcel->setActiveSheetIndex(0)
            ->getRowDimension($fila)
            ->setOutlineLevel( $val["nivel"])
            ->setVisible(true)
            ->setCollapsed(false);

        $this->docexcel->getActiveSheet(0)->setShowSummaryBelow(false);
        $fila++;
        return $fila;
    }
    function agregarMes($sheet, $fila, $val){

        $col_ini_montos = 11;
        $col_ini_formulado = 12;
        $columnaVal = $col_ini_montos;
        $monto_str =  $val['saldo_mb'];
        $monto_for =  $val['importe_formulado'];
        $sw_movimiento = $val['sw_tipo'];
        //si el monto es menor a cero color rojo codigo CMYK
        if($monto_str*1 < 0){
            $color = array('rgb'=>'FF0000');
        }
        else{
            $color = array('rgb'=>'000000');
        }

        if($sw_movimiento == 'titulo'){
            $negrilla = true;
        }else{
            $negrilla = false;
        }

        $sheet->getStyle(($this->equivalencias[$columnaVal]).$fila)->getFont()->applyFromArray(array(  'bold'=>$negrilla,
            'size'=>10,
            'name'=>'Arial',
            'color'=>$color));

        $sheet->getStyle(($this->equivalencias[$columnaVal]).$fila)->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED2);
        $sheet->setCellValueByColumnAndRow($columnaVal,$fila,$monto_str);

        $sheet->getStyle(($this->equivalencias[$columnaVal]).$fila)
              ->getAlignment()
              ->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);


        $sheet->getStyle(($this->equivalencias[$col_ini_formulado]).$fila)->getFont()->applyFromArray(array(  'bold'=>$negrilla,
            'size'=>10,
            'name'=>'Arial',
            'color'=>$color));

        $sheet->getStyle(($this->equivalencias[$col_ini_formulado]).$fila)->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED2);
        $sheet->setCellValueByColumnAndRow($col_ini_formulado,$fila,$monto_for);

        $sheet->getStyle(($this->equivalencias[$col_ini_formulado]).$fila)
            ->getAlignment()
            ->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);
    }
    function checkGrupo($val, $fila){
        $nivel = $val["nivel"];

        if($nivel > $this->ulitmoNivelGrupo){
            $this->grupos[$nivel] = array($fila);
        }
        elseif ($nivel == $this->ulitmoNivelGrupo) {
            //actulizamos posicion final del grupo
            array_push($this->grupos[$nivel],$fila);
        }
        else{
            for ($i = $nivel ; $i++; $i<=$this->ulitmoNivelGrupo){
                $this->cerrarGrupo($i,$val);
                unset($this->grupos[$i]);
            }

            print_r($nivel);
            print_r("\n");
            print_r($this->ulitmoNivelGrupo);
            exit;
            //parametrizamos nuevo grupo
            $this->grupos[$nivel] = array($fila);
        }
        $this->ulitmoNivelGrupo = $nivel;
    }

    function cerrarGrupo($nivel, $val){
        if(isset($this->grupos[$nivel])){
            foreach ($this->grupos[$nivel] as $row){
                $this->docexcel->setActiveSheetIndex(0)
                    ->getRowDimension($row)
                    ->setOutlineLevel( $nivel)
                    ->setVisible(false)
                    ->setCollapsed(true);
            }
        }
    }

    function generarReporte(){
        $this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        //var_dump($this->objWriter);exit;
        $this->objWriter->save($this->url_archivo);
    }
}
?>