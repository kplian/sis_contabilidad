<?php
/**
 * HISTORIAL DE MODIFICACIONES:
 * ISSUE 		   FECHA   			 AUTOR				 DESCRIPCION:
 *  75           28/11/2019     manuel guerra   controlling reporting
 **/
class RReporteTIpoCc
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
        $Tc = 'Tipo Costo';
        $titulo = 'Árbol '.$Tc;
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
        $sheet->getColumnDimension($this->equivalencias[11])->setWidth(70);

        $sheet->getStyle('A2')->getFont()->applyFromArray(array('bold'=>true,
            'size'=>12,
            'name'=>Arial));

        $sheet->getStyle('A2')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
        $sheet->setCellValueByColumnAndRow(0,2,$titulo);
        $sheet->mergeCells('A2:T2');

        //FECHAS
        $sheet->getStyle('A3')->getFont()->applyFromArray(array(
            'bold'=>true,
            'size'=>10,
            'name'=>Arial));



    }
    function imprimirCabecera($sheet, $fila){

        $estilo = array('bold'=>true,
            'italic'=>false,
            'underline'=>false,
            'size'=>12);

        $sheet->getStyle(($this->equivalencias[1]).$fila)->getFont()->applyFromArray($estilo);


        $sheet->getStyle(($this->equivalencias[1]).$fila)->getAlignment()->setHorizontal('center');
        $sheet->setCellValueByColumnAndRow(1,$fila,'Codigo');
        $sheet->mergeCells(($this->equivalencias[1]).$fila.':k'.$fila);
        $sheet->getStyle(($this->equivalencias[1]).$fila)->getAlignment()->setWrapText(true);

        $sheet->setCellValueByColumnAndRow(11,$fila,'Descripcion');
        $sheet->getStyle(($this->equivalencias[11]).$fila)->getAlignment()->setHorizontal('center');
        $sheet->getStyle(($this->equivalencias[11]).$fila)->getFont()->applyFromArray($estilo);


    }


    function imprimirDatos(){
        $datos = $this->objParam->getParametro('datos');
        $sheet = $this->docexcel->getActiveSheet();
        $this->imprimirTitulo($sheet);
        $this->imprimirCabecera($sheet, 5);
        $fila = 6;
        foreach($datos as $val) {
            $fila = $this->imprimirLinea($sheet,$fila, $val);
            $this->agregarDescripcion($sheet,$fila-1,$val);
        }
    }
    function imprimirLinea($sheet, $fila, $val){
        $underline = false;
        $italic = false;
        $texto = $val['codigo'];
        $sw_movimiento = $val['movimiento'];
        if($sw_movimiento == 'no'){
            $negrilla = true;
        }else{
            $negrilla = false;
        }

        $sheet->getStyle(($this->equivalencias[$val["nivel"] - 1]).$fila)->getFont()->applyFromArray(array(
            'bold'=>$negrilla,
            'italic'=>$italic,
            'underline'=>$underline,
            'size'=>10));
        $sheet->getStyle(($this->equivalencias[$val["nivel"] - 1]).$fila)->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_TEXT );

        $sheet->setCellValueByColumnAndRow($val["nivel"] - 1,$fila,$texto);
        $sheet->mergeCells(($this->equivalencias[$val["nivel"] - 1]).$fila.':k'.$fila);
        $sheet->getStyle(($this->equivalencias[$val["nivel"] - 1]).$fila)->getAlignment()->setWrapText(true);
        $this->docexcel->setActiveSheetIndex(0)
            ->getRowDimension($fila)
            ->setOutlineLevel($val["nivel"])
            ->setVisible(true)
            ->setCollapsed(false);
        $this->docexcel->getActiveSheet(0)->setShowSummaryBelow(false);
        $fila++;
        return $fila;
    }
    function agregarDescripcion($sheet, $fila, $val){

        $col_ini_montos = 11;
        $columnaVal = $col_ini_montos;
        $sw_movimiento = $val['movimiento'];
        $texto = $val['descripcion'];

        if($sw_movimiento == 'no'){
            $negrilla = true;
        }else{
            $negrilla = false;
        }

        $sheet->getStyle(($this->equivalencias[$columnaVal]).$fila)->getFont()->applyFromArray(array( 'bold'=>$negrilla,
            'size'=>10,
            'name'=>'Arial'));

        $sheet->setCellValueByColumnAndRow($columnaVal,$fila,$texto);

        $sheet->getStyle(($this->equivalencias[$columnaVal]).$fila)
            ->getAlignment()
            ->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_RIGHT);

    }

    function generarReporte(){
        $this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);
    }
}
?>