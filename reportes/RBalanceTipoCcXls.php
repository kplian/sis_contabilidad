<?php
//incluimos la libreria
//echo dirname(__FILE__);
//include_once(dirname(__FILE__).'/../PHPExcel/Classes/PHPExcel.php');

class RBalanceTipoCcXls
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
		$titulo = 'Árbol de Ánalisis de Costos ';
		$codigos = $this->objParam->getParametro('codigos');		
		$fechas = 'Del '.$this->objParam->getParametro('desde').' al '.$this->objParam->getParametro('hasta');
		$moneda = 'Expresado en moneda '.$this->objParam->getParametro('moneda');
		
		//TODO imprimir titulo
		
		$sheet->getColumnDimension($this->equivalencias[0])->setWidth(2);
		$sheet->getColumnDimension($this->equivalencias[1])->setWidth(2);
		$sheet->getColumnDimension($this->equivalencias[2])->setWidth(2);
		$sheet->getColumnDimension($this->equivalencias[3])->setWidth(2);
		$sheet->getColumnDimension($this->equivalencias[4])->setWidth(2);
		$sheet->getColumnDimension($this->equivalencias[5])->setWidth(2);
		$sheet->getColumnDimension($this->equivalencias[6])->setWidth(2);
		$sheet->getColumnDimension($this->equivalencias[7])->setWidth(45);
		$sheet->getColumnDimension($this->equivalencias[8])->setWidth(2);
		$sheet->getColumnDimension($this->equivalencias[9])->setWidth(2);
		$sheet->getColumnDimension($this->equivalencias[10])->setWidth(2);
		$sheet->getColumnDimension($this->equivalencias[11])->setWidth(2);
		$sheet->getColumnDimension($this->equivalencias[12])->setWidth(2);
		$sheet->getColumnDimension($this->equivalencias[13])->setWidth(2);
		$sheet->getColumnDimension($this->equivalencias[14])->setWidth(2);
		$sheet->getColumnDimension($this->equivalencias[15])->setWidth(2);
		$sheet->getColumnDimension($this->equivalencias[16])->setWidth(8);
		
		//$sheet->setCellValueByColumnAndRow(0,1,$this->objParam->getParametro('titulo_rep'));
		$sheet->getStyle('A1')->getFont()->applyFromArray(array('bold'=>true,
															    'size'=>12,
															    'name'=>Arial));
																
		$sheet->getStyle('A1')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		$sheet->setCellValueByColumnAndRow(0,1,strtoupper($titulo));		
		$sheet->mergeCells('A1:I1');
		
		//DEPTOS TITLE
		$sheet->getStyle('A2')->getFont()->applyFromArray(array(
															    'bold'=>true,
															    'size'=>10,
															    'name'=>Arial));	
																															
		$sheet->getStyle('A2')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		$sheet->setCellValueByColumnAndRow(0,2,strtoupper('DEPTOS: '.$codigos));		
		$sheet->mergeCells('A2:I2');
		//FECHAS
		$sheet->getStyle('A3')->getFont()->applyFromArray(array(
															    'bold'=>true,
															    'size'=>10,
															    'name'=>Arial));	
																															
		$sheet->getStyle('A3')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		$sheet->setCellValueByColumnAndRow(0,3,$fechas);		
		$sheet->mergeCells('A3:I3');
		
		
		$sheet->getStyle('A4')->getFont()->applyFromArray(array(
															    'bold'=>true,
															    'size'=>10,
															    'name'=>Arial));	
																															
		$sheet->getStyle('A4')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		$sheet->setCellValueByColumnAndRow(0,3,$moneda);		
		$sheet->mergeCells('A4:I4');
		
	}
			
	function imprimeDatos(){
		$datos = $this->objParam->getParametro('datos');
		$sheet = $this->docexcel->getActiveSheet();
		//Cabecera
		$this->imprimeTitulo($sheet);	
		
		
		$fila = 5;
		$columnas = 0;
		$moneda = $this->objParam->getParametro('moneda');
		
		
		
		/////////////////////***********************************Detalle***********************************************
		foreach($datos as $val) {
				
				//necesita espacios
					$sw_espacio = 1;
					$sw_detalle = 1;
						
							
					//TABS
					$tabs = '';
					//signo	
		        	$signo = '';	
		        	
					
					//alineacion del texto	
		        	//$posicion = PHPExcel_Style_Alignment::HORIZONTAL_RIGHT;	
					$underline = false;
					$bold = false;
					$italic = false;
					
					
				
				//////////////////
				//Coloca el texto
				///////////////////////
				
				
				
				// Formateo el texto
		        
				$texto = $tabs.'('.$val['codigo'].') '.$val['descripcion'];
				$sheet->getStyle(($this->equivalencias[$val["nivel"] - 1]).$fila)->getFont()->applyFromArray(array(
																	    'bold'=>$bold,
																	    'italic'=>$italic,
																	    'underline'=>$underline,
																	    'size'=>8,
																	    'name'=>Arial));
																		
				$sheet->getStyle(($this->equivalencias[$val["nivel"] - 1]).$fila)->getAlignment()->setHorizontal($posicion);															
				$sheet->setCellValueByColumnAndRow($val["nivel"] - 1,$fila,$texto);
				$sheet->mergeCells(($this->equivalencias[$val["nivel"] - 1]).$fila.':H'.$fila);
				
				$sheet->getStyle(($this->equivalencias[$val["nivel"] - 1]).$fila)->getAlignment()->setWrapText(true);
				
				
				
				//////////////////////
				//coloca los montos
				/////////////////////
				
				if($moneda=='base'){
					$monto_str =  $val['monto'];
				}
				else{
					$monto_str =  $val['monto_mt'];
				}
				
				
				//si el monto es menor a cero color rojo codigo CMYK
				if($monto_str*1 < 0){
					$color = array('rgb'=>'FF0000');
				}
				else{
					$color = array('rgb'=>'000000');
				}
				
				
				
				
				
				
				
				$sheet->getStyle(($this->equivalencias[$val["nivel"]+7]).$fila)->getFont()->applyFromArray(array(
																    'bold'=>true,
																    'size'=>10,
																    'name'=>Arial,
																    'color'=>$color));
																	
				 $sheet->mergeCells(($this->equivalencias[$val["nivel"] + 7]).$fila.':Q'.$fila);													
				$sheet->getStyle(($this->equivalencias[$val["nivel"]+7]).$fila)->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_NUMBER_COMMA_SEPARATED2); 
				//$sheet->setCellValueByColumnAndRow(1,$fila,'');
			    //$sheet->setCellValueByColumnAndRow(2,$fila,'');			   
			    $sheet->setCellValueByColumnAndRow($val["nivel"]+7,$fila,$monto_str);
				$sheet->getStyle(($this->equivalencias[$val["nivel"]+7]).$fila)
    					->getAlignment()
    					->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_LEFT);
				$fila++;
			
		}
		//************************************************Fin Detalle***********************************************
		
	}
    

	function formatearTextoDetalle($texto){
		$tex=  ucwords(strtolower($texto));	
		$tex = str_replace("Y", "y", $tex);
		$tex = str_replace("De", "de", $tex);
		$tex = str_replace("En", "en", $tex);
		$tex = str_replace("Del", "del", $tex);
		
		return $tex;
	}
	
	function generarReporte(){
		//echo $this->nombre_archivo; exit;
		// Set active sheet index to the first sheet, so Excel opens this as the first sheet
		$this->docexcel->setActiveSheetIndex(0);
		$this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
		$this->objWriter->save($this->url_archivo);	
		
	}	
	
	function getLlaveFila($val){
		return  $val['descripcion'];		
		
	}
	
	
	

}

?>