<?php

// Extend the TCPDF class to create custom MultiRow
class RResultados extends  ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $desde;
	var $hasta;
	var $titulo;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $codigos;
	var $total_activo;
	var $total_pasigo;
	var $total_patrimonio;
	
	function datosHeader ( $detalle,  $titulo,$desde, $hasta, $codigos) {
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->titulo = $titulo;
		$this->desde = $desde;
		$this->hasta = $hasta;
		$this->codigos = $codigos;
		
		//$this->SetMargins(5, 22.5, 5);
		$this->SetMargins(5,34);
	}
	
	function Header() {
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], $this->ancho_hoja, 5, 30, 10);
		$this->ln(5);
		$this->SetFont('','BU',12);
		$this->Cell(0,5, strtoupper($this->titulo), 0 , 1,'C');
		$this->SetFont('','BU',11);
		$this->Cell(0,5,'Depto: ('.$this->codigos.')',0,1,'C');
		$this->SetFont('','BU',10);		
		$this->Cell(0,5,'Del '.$this->desde.' al '.$this->hasta,0,1,'C');
		
		
		
			
		
   }
	
	function formatearTextoDetalle($texto){
		$tex=  ucwords(strtolower($texto));	
		$tex = str_replace("Y", "y", $tex);
		$tex = str_replace("De", "de", $tex);
		$tex = str_replace("En", "en", $tex);
		$tex = str_replace("Del", "del", $tex);
		
		return $tex;
	}	
	
	function generarReporte() {
		
		$this->total_activo = 0;
	    $this->total_pasigo = 0;
	    $this->total_patrimonio = 0;		
		
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		//configuracion de la tabla
		$tabs = '';
        $sw_detalle = 1;
        foreach ($this->datos_detalle as $val) {
			if($val['visible'] == 'si'){
						
						
					//necesita espacios
					if ($val['origen'] != 'detalle'){
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
							$this->ln();	
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
		        	$posicion = 'L';	
		        	if($val['posicion']== 'center'){
					 $posicion = 'C';	
					}
					if(($val['posicion']== 'right')){
					 $posicion = 'R';	
					}
					
					$text_format = '';
					//subrayado
					if($val['subrayar'] == 'si'){
					    $text_format = 'U';
					}
					//negrita
					if($val['negrita'] == 'si'){
					    $text_format = 'B'.$text_format;
					}
					//cursiva
					if($val['cursiva'] == 'si'){
					    $text_format = 'I'.$text_format;
					}
					
					
					 $this->SetFont('',$text_format,$val['font_size']);
		        	// Formateo el texto
		        	
					if(isset($val['nombre_variable']) && $val['nombre_variable'] != ''){
					   $texto = $tabs.$val['nombre_variable'];
					   
					}
					else{
						$texto = $tabs.$val['desc_cuenta'];
						if($val['origen'] == 'detalle'){
							$texto = $this->formatearTextoDetalle($texto);	
						}
					}
		
		            //coloca el signo
		            $this->Cell(10,3.5,$val['signo'],'',0,'C');
				   
			        //coloca el texto
					$this->Cell(100,3.5,$texto,'',0,$posicion);
					
					//definir monto
					if ($val['origen'] == 'titulo'){
						$monto_str = '';
					}
					else {
						//si el monto es menor a cero color rojo codigo CMYK
						if($val['monto']*1 < 0){
							$this->SetTextColor(0,100,100,0,false,'');
						}
						$monto_str = number_format( $val['monto'] ,2 , ',' , '.' );
					}
					
					
					if($val['montopos'] == 1){
					   $this->Cell(25,3.5,$monto_str ,'',0,'R');
					   $this->Cell(25,3.5,"",'',0,'R');
					   $this->Cell(25,3.5,"",'',0,'R');
					}
					elseif($val['montopos'] == 2){
					   $this->SetFont('','B',10);
					   $this->Cell(25,3.5,"",'',0,'R');
					   $this->Cell(25,3.5, $monto_str ,'',0,'R');
					   $this->Cell(25,3.5,"",'',0,'R');
					   $this->SetFont('','',9);
					  
					}
					else{
						$this->SetFont('','BU',11);
				        $this->Cell(25,3.5, "" ,'',0,'R');
						$this->Cell(25,3.5,"",'',0,'R');
						$this->Cell(25,3.5, $monto_str ,'',0,'R');	
						$this->SetFont('','',9);
					}
					//Setea colo dfecto
					$this->SetTextColor(0,-1,-1,-1,false,'');
					
					$this->ln();	
			  }
		}	//Titulos de columnas inferiores 
								
			$this->ln();
	}
	
	
}
?>

