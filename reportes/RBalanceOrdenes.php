<?php

// Extend the TCPDF class to create custom MultiRow
class RBalanceOrdenes extends  ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $desde;
	var $hasta;
	var $nivel;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $codigos;
	var $total_ordenes;
	var $tipo_balance;
	var $incluir_cierre;
	
	function datosHeader ( $detalle, $nivel, $desde, $hasta, $codigos, $tipo_balance, $incluir_cierre) {
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->nivel = $nivel;
		$this->desde = $desde;
		$this->hasta = $hasta;
		$this->codigos = $codigos;
		$this->incluir_cierre = $incluir_cierre;
		$this->tipo_balance = $tipo_balance;
		//$this->SetMargins(5, 22.5, 5);
		$this->SetMargins(5,40);
	}
	
	function Header() {
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], $this->ancho_hoja, 5, 30, 10);
		$this->ln(5);
		$this->SetFont('','BU',12);
		
		$this->Cell(0,5,'ÁRBOL DE ORDENES DE COSTOS (BS)',0,1,'C');
		
		$this->SetFont('','BU',11);
		$this->Cell(0,5,'Depto: ('.$this->codigos.')',0,1,'C');
		$this->SetFont('','BU',10);		
		$this->Cell(0,5,'Del '.$this->desde.' al '.$this->hasta,0,1,'C');
		$this->SetFont('','BU',8);		
		$this->Cell(0,5,'Incluye Cierres: '.$this->incluir_cierre,0,1,'C');
		
		
		$this->Ln(3);
		$this->SetFont('','B',10);
		
		//REporte de unasola columna de monto
		if($this->nivel == 1 || $this->nivel > 3 ){
			//Titulos de columnas superiores
			$this->Cell(160,3.5,'Ordenes','',0,'C');
			$this->Cell(40,3.5,'Montos (Bs)','',0,'C');
			$this->ln();	
		}
		//reporte de dos columnas de montos
		if($this->nivel == 2 ){
			//Titulos de columnas superiores
			$this->Cell(154,3.5,'Ordenes','',0,'C');
			$this->Cell(23,3.5,'Mon','',0,'R');
			$this->Cell(23,3.5,'tos (Bs)','',0,'L');
			$this->ln();	
			
		}
		
		if($this->nivel == 3 ){
			//Titulos de columnas superiores
			$this->Cell(131,3.5,'Ordenes','',0,'C');
			$this->Cell(23,3.5,'','',0,'R');
			$this->Cell(23,3.5,'Montos (Bs)','',0,'C');
			$this->Cell(23,3.5,'','',0,'L');
			$this->ln();
			
		}
		
   }
	
	function generarReporte() {
		
		$this->total_ordenes = 0;		
		//Reporte de unasola columna de monto
		if($this->nivel == 1 || $this->nivel > 3 ){
		    $this->generarReporte1C();
		}
		//reporte de dos columnas de montos
		if($this->nivel == 2 ){
		     $this->generarReporte2C();
		}
		//reporte de tres columnas de montos
		if($this->nivel == 3 ){
		     $this->generarReporte3C();
		}
		
		//escribe formula contabla
		$this->SetFont('times', 'BI', 17);
		$total_ordenes = number_format( $this->total_ordenes , 2 , '.' , ',' );
		
		$sw_dif = 0;
		
			
			
		$formula = "TOTAL ORDENES";
		$this->Write(0, $formula, '', 0, 'C', true, 0, false, false, 0);
		$formula = "$total_ordenes";
		$this->Write(0, $formula, '', 0, 'C', true, 0, false, false, 0);
		
		
	}
	function definirTotales($val){
		if($val ["nivel"] ==1 ){
			$this->total_ordenes = $this->total_ordenes + $val['monto'];
		}
		
	}
	
	function generarReporte1C() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		//configuracion de la tabla
		$this->SetFont('','',9);
		
        foreach ($this->datos_detalle as $val) {
	       		
			$this->definirTotales($val);	
	       	$tabs = "";
		    for($i = 1; $i < $val ["nivel"]; $i++){
		    	$tabs = $tabs."\t\t\t\t";
		    } 
        	  
	      
			$this->Cell(160,3.5,$tabs.'('.$val['codigo'].') '.$val['desc_orden'],'',0,'L');
			//si el monto es menor a cero color rojo codigo CMYK
			if($val['monto']*1 < 0){
				$this->SetTextColor(0,100,100,0,false,'');
			}
           if($val['nivel'] == 1){
           	   $this->SetFont('','BU',11);
			   $this->Cell(40,3.5, number_format( $val['monto'] , 2 , '.' , ',' ) ,'',0,'R');
			   $this->SetFont('','',9);
			  
			}
		   if($val['nivel'] == 2){
           	   $this->SetFont('','BU',10);
			   $this->Cell(40,3.5, number_format( $val['monto'] , 2 , '.' , ',' ) ,'',0,'R');
			   $this->SetFont('','',9);
			  
			}
			else{
				$this->Cell(40,3.5, number_format( $val['monto'] , 2 , '.' , ',' ) ,'',0,'R');
			}
			
			$this->ln();
			
			//colores por defecto
			$this->SetTextColor(0,-1,-1,-1,false,'');		
				
			
		}	//Titulos de columnas inferiores 
			$this->Cell(160,3.5,'','',0,'L');
			$this->Cell(40,3.5,'','',0,'R');			
			$this->ln();
	}
	
	function generarReporte2C() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		//configuracion de la tabla
		$this->SetFont('','',9);
		
        $tabs = '';
        
        foreach ($this->datos_detalle as $val) {
        	$this->definirTotales($val);
			if($val['nivel'] == 2){
				$tabs = "\t\t\t\t";
			}
			else{
				$tabs = "";
			}
        	  
	       // $this->Cell(40,3.5,,'LTR',0,'L');
			$this->Cell(154,3.5,$tabs.'('.$val['codigo'].') '.$val['desc_orden'],'',0,'L');
			
			if($val['monto']*1 < 0){
				$this->SetTextColor(0,100,100,0,false,'');
			}
			
			if($val['nivel'] == 2){
			   $this->Cell(23,3.5, number_format( $val['monto'] , 2 , '.' , ',' ) ,'',0,'R');
			   $this->Cell(23,3.5,"",'',0,'R');
			}
			else{
				$this->SetFont('','BU',10);
		        $this->Cell(23,3.5, "" ,'',0,'R');
				$this->Cell(23,3.5, number_format( $val['monto'], 2 , '.' , ',' ) ,'',0,'R');	
				$this->SetFont('','',9);
			}
			
			$this->ln();	
			$this->SetTextColor(0,-1,-1,-1,false,'');	
			
		}	//Titulos de columnas inferiores 
			//$this->Cell(40,3.5,'','LBR',0,'L');	
			$this->Cell(154,3.5,'','',0,'L');
			$this->Cell(23,3.5,'','',0,'R');	
			$this->Cell(23,3.5,'','',0,'R');					
			$this->ln();
	}

    function generarReporte3C() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		//configuracion de la tabla
		$this->SetFont('','',9);
		
        $tabs = '';
        
        foreach ($this->datos_detalle as $val) {
        	$this->definirTotales($val);
			if($val['nivel'] == 3){
				$tabs = "\t\t\t\t\t\t\t\t";
			}
			elseif($val['nivel'] == 2){
				$tabs = "\t\t\t\t";
			}
			else{
				$tabs = "";
			}
			
        	  
	       // $this->Cell(40,3.5,,'LTR',0,'L');
			$this->Cell(131,3.5,$tabs.'('.$val['codigo'].') '.$val['desc_orden'],'',0,'L');
			
			//si el monto es menor a cero color rojo codigo CMYK
			if($val['monto']*1 < 0){
				$this->SetTextColor(0,100,100,0,false,'');
			}
			
			if($val['nivel'] == 3){
			   $this->Cell(23,3.5, number_format( $val['monto'] ,2 , '.' , ',' ) ,'',0,'R');
			   $this->Cell(23,3.5,"",'',0,'R');
			   $this->Cell(23,3.5,"",'',0,'R');
			}
			elseif($val['nivel'] == 2){
			   $this->SetFont('','B',10);
			   $this->Cell(25,3.5,"",'',0,'R');
			   $this->Cell(22,3.5, number_format( $val['monto'] , 2 , '.' , ',' ) ,'',0,'R');
			   $this->Cell(22,3.5,"",'',0,'R');
			   $this->SetFont('','',9);
			  
			}
			else{
				$this->SetFont('','BU',11);
		        $this->Cell(25,3.5, "" ,'',0,'R');
				$this->Cell(22,3.5,"",'',0,'R');
				$this->Cell(22,3.5, number_format( $val['monto'] , 2 , '.' , ',' ) ,'',0,'R');	
				
				$this->SetFont('','',9);
			}
			//Setea colo dfecto
			$this->SetTextColor(0,-1,-1,-1,false,'');
			
			$this->ln();	
				
			
		}	//Titulos de columnas inferiores 
			//$this->Cell(40,3.5,'','LBR',0,'L');	
			$this->Cell(131,3.5,'','',0,'L');
			$this->Cell(25,3.5,'','',0,'R');	
			$this->Cell(22,3.5,'','',0,'R');
			$this->Cell(22,3.5,'','',0,'R');						
			$this->ln();
	}  
}
?>

