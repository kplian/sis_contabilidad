<?php
//incluimos la libreria
//echo dirname(__FILE__);
//include_once(dirname(__FILE__).'/../PHPExcel/Classes/PHPExcel.php');
/*
**************************************************************************
 ISSUE  SIS       EMPRESA       FECHA       AUTOR       DESCRIPCION
 #154    CONTA     ETR           01/08/2019  RCM         Corrección por actualización de PHP 7. Se cambia el string Arial por cadena 'Arial'
***************************************************************************
*/
class RResultadosXls
{
	private $docexcel;
	private $objWriter;
	private $nombre_archivo;
	private $hoja;
	private $columnas=array();
	private $fila;
	private $equivalencias=array();

	private $indice, $m_fila, $titulo;
	private $swEncabezado=0; //variable que define si ya se imprimi� el encabezado
	private $objParam;
	public  $url_archivo;

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


	function imprimeTitulo($sheet){
		$titulo = $this->objParam->getParametro('titulo_rep');
		$codigos = $this->objParam->getParametro('codigos');
		$fechas = 'Del '.$this->objParam->getParametro('desde').' al '.$this->objParam->getParametro('hasta');

		//TODO imprimir titulo

		$sheet->getColumnDimension($this->equivalencias[0])->setWidth(45);
		$sheet->getColumnDimension($this->equivalencias[1])->setWidth(12);
		$sheet->getColumnDimension($this->equivalencias[2])->setWidth(14);
		$sheet->getColumnDimension($this->equivalencias[3])->setWidth(16);

		//$sheet->setCellValueByColumnAndRow(0,1,$this->objParam->getParametro('titulo_rep'));
		$sheet->getStyle('A1')->getFont()->applyFromArray(array('bold'=>true,
															    'size'=>12,
															    'name'=>'Arial')); //#154

		$sheet->getStyle('A1')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		$sheet->setCellValueByColumnAndRow(0,1,strtoupper($titulo));
		$sheet->mergeCells('A1:D1');

		//DEPTOS TITLE
		$sheet->getStyle('A2')->getFont()->applyFromArray(array(
															    'bold'=>true,
															    'size'=>10,
															    'name'=>'Arial'));	 //#154

		$sheet->getStyle('A2')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		$sheet->setCellValueByColumnAndRow(0,2,strtoupper('DEPTOS: '.$codigos));
		$sheet->mergeCells('A2:D2');
		//FECHAS
		$sheet->getStyle('A3')->getFont()->applyFromArray(array(
															    'bold'=>true,
															    'size'=>10,
															    'name'=>'Arial'));	 //#154

		$sheet->getStyle('A3')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		$sheet->setCellValueByColumnAndRow(0,3,$fechas);
		$sheet->mergeCells('A3:D3');

	}

	function imprimeDatos(){
		$datos = $this->objParam->getParametro('datos');
		$sheet = $this->docexcel->getActiveSheet();
		//Cabecera
		$this->imprimeTitulo($sheet);


		$fila = 4;
		$columnas = 0;



		/////////////////////***********************************Detalle***********************************************
		foreach($datos as $val) {
			if($val['visible'] == 'si'){

				//necesita espacios
					if ($val['origen'] != 'detalle' && $val['origen'] != 'detalle_formula'){
						$sw_espacio = 1;
						$sw_detalle = 1;
					}
					else{
						//solo coloca espacios si es el primer detalle
						if ($sw_detalle == 1){
							$sw_espacio = 1;
							$sw_detalle = 0; //deshabilita los espacion para el siguiente detalle
						}
						else{
							$sw_espacio = 0;
						}
					}

					//INTRODUCE ESPACIOS PREVIOS
					if ($sw_espacio == 1){
						for($i=0; $i<$val['espacio_previo']; $i++){
							$filas++;
						}
					}


					//TABS
					$tabs = '';
					if($val['montopos'] == 1){
				    	$tabs = "\t\t\t\t";
				    }
				    if($val['montopos'] == 2){
				    	$tabs = "\t\t";
				    }

		        	//signo
		        	$signo = '';
		        	if(isset($val['signo'])){
					 $signo = $val['signo'];
					}

					//alineacion del texto
		        	$posicion = PHPExcel_Style_Alignment::HORIZONTAL_LEFT;
		        	if($val['posicion']== 'center'){
					 $posicion = PHPExcel_Style_Alignment::HORIZONTAL_CENTER;
					}
					if(($val['posicion']== 'right')){
					 $posicion = PHPExcel_Style_Alignment::HORIZONTAL_RIGHT;
					}


					//subrayado
					if($val['subrayar'] == 'si'){
					    $underline = true;
					}
					else{
						 $underline = false;
					}

					//negrita
					if($val['negrita'] == 'si'){
					    $bold = true;
					}
					else{
						$bold = false;
					}
					//cursiva
					if($val['cursiva'] == 'si'){
					    $italic = true;
					}
					else{
						 $italic = false;
					}





				//////////////////
				//Coloca el texto
				///////////////////////



				// Formateo el texto

					if(isset($val['nombre_variable']) && $val['nombre_variable'] != ''){
					   $texto = $tabs.$val['nombre_variable'];

					}
					else{
						$texto = $tabs.'('.trim($val['codigo_cuenta'].') '.$val['desc_cuenta']);
						if($val['origen'] == 'detalle'  ||  $val['origen'] == 'detalle_formula'){
							$texto = $this->formatearTextoDetalle($texto);
						}
					}

				$sheet->getStyle(($this->equivalencias[0]).$fila)->getFont()->applyFromArray(array(
																	    'bold'=>$bold,
																	    'italic'=>$italic,
																	    'underline'=>$underline,
																	    'size'=>$val['font_size'],
																	    'name'=>'Arial')); //#154

				$sheet->getStyle(($this->equivalencias[0]).$fila)->getAlignment()->setHorizontal($posicion);
				$sheet->setCellValueByColumnAndRow(0,$fila,substr($texto, 0, 40));  //ojo revisar es apra mostrar menos caracteres


				//////////////////////
				//coloca los montos
				/////////////////////

				//definir monto
				if ($val['origen'] == 'titulo'){
					$monto_str = '';
					$color = array('rgb'=>'000000');
				}
				else {
					//si el monto es menor a cero color rojo codigo CMYK
					if($val['monto']*1 < 0){
						$color = array('rgb'=>'FF0000');
					}
					else{
						$color = array('rgb'=>'000000');
					}
					$monto_str =  $val['monto'];
				}


				if($val['montopos'] == 1){
					  $sheet->getStyle(($this->equivalencias[1]).$fila)->getFont()->applyFromArray(array(
																	    'bold'=>false,
																	    'size'=>8,
																	    'name'=>'Arial', //#154
																	    'color'=>$color));

					   $sheet->getStyle(($this->equivalencias[1]).$fila)->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED2);


					   $sheet->setCellValueByColumnAndRow(1,$fila,$monto_str);
				       $sheet->setCellValueByColumnAndRow(2,$fila,'');
				       $sheet->setCellValueByColumnAndRow(3,$fila,'');
				}
				elseif($val['montopos'] == 2){
					  $sheet->getStyle(($this->equivalencias[2]).$fila)->getFont()->applyFromArray(array(
																	    'bold'=>false,
																	    'size'=>9,
																	    'name'=>'Arial', //#154
																	    'color'=>$color));

					   $sheet->getStyle(($this->equivalencias[2]).$fila)->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED2);

				       $sheet->setCellValueByColumnAndRow(1,$fila,'');
				       $sheet->setCellValueByColumnAndRow(2,$fila,$monto_str);
				       $sheet->setCellValueByColumnAndRow(3,$fila,'');

				}
				else{
					  $sheet->getStyle(($this->equivalencias[3]).$fila)->getFont()->applyFromArray(array(
																	    'bold'=>true,
																	    'size'=>10,
																	    'name'=>'Arial', //#154
																	    'color'=>$color));


					   $sheet->getStyle(($this->equivalencias[3]).$fila)->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED2);

					   $sheet->setCellValueByColumnAndRow(1,$fila,'');
				       $sheet->setCellValueByColumnAndRow(2,$fila,'');
				       $sheet->setCellValueByColumnAndRow(3,$fila,$monto_str);
				}

				$fila++;
			}
		}
		//************************************************Fin Detalle***********************************************

	}
    /* Imprime las dependencias ..*/
    function imprimeDatosExtendido(){

		$datos = $this->objParam->getParametro('datos');
		$sheet = $this->docexcel->getActiveSheet();
		//Cabecera
		$this->imprimeTitulo($sheet);
		$fila = 5;
		$columnas = 0;

		$titulos_columnas = array();
		$titulos_filas = array();
		$indice_columnas = 1;
		$indice_filas = $fila  + 1;


		$styleArrayAllBorders = array(
						      'borders' => array(
						          'allborders' => array(
						              'style' => PHPExcel_Style_Border::BORDER_THIN
						          )
						      )
						  );




		foreach($datos as $val) {
			if($val['visible'] == 'si'){

				//registra una nueva columna
				if(!array_key_exists (  $val['plantilla'], $titulos_columnas )){
					$titulos_columnas[$val['plantilla']] = $indice_columnas;
					//Agrega la columna
					//$sheet->getStyle($indice_columnas.$fila)->applyFromArray($styleArrayAllBorders);
					$sheet->setCellValueByColumnAndRow($indice_columnas,$fila,$val['nombre_columna']);
					$sheet->getColumnDimension($this->equivalencias[$indice_columnas])->setWidth(10);

					$indice_columnas ++;



				}

				//registra una nueva fila
				if(isset($val['nombre_variable']) && $val['nombre_variable'] != ''){
					   $texto = $val['nombre_variable'];

					}
				else{
						//$texto = $val['desc_cuenta'];

						$texto = '('.trim($val['codigo_cuenta'].') '.$val['desc_cuenta']);
						if($val['origen'] == 'detalle'  || $val['origen'] == 'detalle_formula'){
							$texto = $this->formatearTextoDetalle($texto);
						}
				}

				if(!array_key_exists (  $this->getLlaveFila($val), $titulos_filas )){

					$titulos_filas[$this->getLlaveFila($val)] = $indice_filas;
					//Agrega la fila
					$sheet->setCellValueByColumnAndRow(0,$indice_filas, $texto);
					$indice_filas ++;
				}



				if ($val['origen'] == 'titulo'){
					$monto_str = '';
					$color = array('rgb'=>'000000');
				}
				else {
					//si el monto es menor a cero color rojo codigo CMYK
					if($val['monto']*1 < 0){
						$color = array('rgb'=>'FF0000');
					}
					else{
						$color = array('rgb'=>'000000');
					}
					$monto_str =  $val['monto'];
				}
				//registra el monto correspondiente
				$sheet->getStyle(($this->equivalencias[$titulos_columnas[$val['plantilla']]]).$titulos_filas[$this->getLlaveFila($val)])->getFont()->applyFromArray(array(
																	    'bold'=>false,
																	    'size'=>10,
																	    'name'=>'Arial', //#154
																	    'color'=>$color));

				$sheet->getStyle(($this->equivalencias[$titulos_columnas[$val['plantilla']]]).$titulos_filas[$this->getLlaveFila($val)])->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED2);

				$sheet->setCellValueByColumnAndRow($titulos_columnas[$val['plantilla']],$titulos_filas[$this->getLlaveFila($val)], $monto_str);


			}
		}




         $sheet->getStyle($this->equivalencias[0].$fila.':'.$this->equivalencias[$indice_columnas-2].$fila)->applyFromArray($styleArrayAllBorders);
		 $sheet->getStyle($this->equivalencias[0].$fila.':'.$this->equivalencias[$indice_columnas-2].$fila)->getFont()->applyFromArray(array(
															    'bold'=>true,
															    'size'=>10,
															    'name'=>'Arial'));	 //#154

		 $sheet->getStyle($this->equivalencias[0].$fila.':'.$this->equivalencias[$indice_columnas-2].$fila)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);



		for($k = 0; $k < $indice_columnas -1; $k ++){


		     $sheet->getColumnDimension($this->equivalencias[$k])->setAutoSize(true);
			 $sheet->calculateColumnWidths();
			 $titlecolwidth = $sheet->getColumnDimension($this->equivalencias[$k])->getWidth();
			 $sheet->getColumnDimension($this->equivalencias[$k])->setAutoSize(false);
			 $sheet->getColumnDimension($this->equivalencias[$k])->setWidth( $titlecolwidth + ((int)$titlecolwidth*0.12));

		}



    }

	function formatearTextoDetalle($texto){
		$tex=  ucwords(strtolower($texto));
		$tex = str_replace("Y", "y", $tex);
		$tex = str_replace("De", "de", $tex);
		$tex = str_replace("En", "en", $tex);
		$tex = str_replace("Del", "del", $tex);

		return trim($tex);
	}

	function generarReporte(){
		//echo $this->nombre_archivo; exit;
		// Set active sheet index to the first sheet, so Excel opens this as the first sheet
		$this->docexcel->setActiveSheetIndex(0);
		$this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
		$this->objWriter->save($this->url_archivo);

	}

	function getLlaveFila($val){

		if(isset($val['codigo_cuenta']) && $val['codigo_cuenta'] != '' ){
			return  $val['codigo_cuenta'];
		}

		//registra una nueva fila
		if(isset($val['nombre_variable']) && $val['nombre_variable'] != ''){
			return $val['nombre_variable'];

		}
		else{
			return  $val['desc_cuenta'];

		}


	}




}

?>