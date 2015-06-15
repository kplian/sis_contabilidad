<?php

// Extend the TCPDF class to create custom MultiRow
class RBalanceGeneral extends  ReportePDF {
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
	
	function datosHeader ( $detalle, $nivel, $desde, $hasta, $codigos) {
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->nivel = $nivel;
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
		$this->Cell(0,5,'BALANCE GENERAL (BS)',0,1,'C');
		$this->SetFont('','BU',11);
		$this->Cell(0,5,'Depto: ('.$this->codigos.')',0,1,'C');
		$this->SetFont('','BU',10);		
		$this->Cell(0,5,'Del '.$this->desde.' al '.$this->hasta,0,1,'C');
		
		
		$this->Ln(3);
		$this->SetFont('','B',10);
		
		//REporte de unasola columna de monto
		if($this->nivel == 1 || $this->nivel > 3 ){
			//Titulos de columnas superiores
			$this->Cell(160,3.5,'Nombre Cuenta','',0,'C');
			$this->Cell(40,3.5,'Montos (Bs)','',0,'C');
			$this->ln();	
		}
		//reporte de dos columnas de montos
		if($this->nivel == 2 ){
			//Titulos de columnas superiores
			$this->Cell(140,3.5,'Cuentas','',0,'C');
			$this->Cell(20,3.5,'Mon','',0,'R');
			$this->Cell(20,3.5,'tos (Bs)','',0,'L');
			$this->ln();	
			
		}
		
		if($this->nivel == 3 ){
			//Titulos de columnas superiores
			$this->Cell(140,3.5,'Cuentas','',0,'C');
			$this->Cell(20,3.5,'','',0,'R');
			$this->Cell(20,3.5,'Montos (Bs)','',0,'C');
			$this->Cell(20,3.5,'','',0,'L');
			$this->ln();
			
		}
		
   }
	
	function generarReporte() {		
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
		
	}
	function generarReporte1C() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		//configuracion de la tabla
		$this->SetFont('','',9);
		
        foreach ($this->datos_detalle as $val) {
	       	$tabs = "";
		    for($i = 1; $i < $val ["nivel"]; $i++){
		    	$tabs = $tabs."\t\t\t\t";
		    } 
        	  
	      
			$this->Cell(160,3.5,$tabs.'('.$val['nro_cuenta'].') '.$val['nombre_cuenta'],'LTR',0,'L');
			//si el monto es menor a cero color rojo codigo CMYK
			if($val['monto']*1 < 0){
				$this->SetTextColor(0,100,100,0,false,'');
			}
			$this->Cell(40,3.5, number_format( $val['monto'] , 0 , '.' , ',' ) ,'LTR',0,'R');
			$this->ln();
			
			//colores por defecto
			$this->SetTextColor(0,-1,-1,-1,false,'');		
				
			
		}	//Titulos de columnas inferiores 
			$this->Cell(160,3.5,'','T',0,'L');
			$this->Cell(40,3.5,'','T',0,'R');			
			$this->ln();
	}
	
	function generarReporte2C() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		//configuracion de la tabla
		$this->SetFont('','',9);
		
        $tabs = '';
        
        foreach ($this->datos_detalle as $val) {
        	
			if($val['nivel'] == 2){
				$tabs = "\t\t\t\t";
			}
			else{
				$tabs = "";
			}
        	  
	       // $this->Cell(40,3.5,,'LTR',0,'L');
			$this->Cell(140,3.5,$tabs.'('.$val['nro_cuenta'].') '.$val['nombre_cuenta'],'LTR',0,'L');
			
			if($val['monto']*1 < 0){
				$this->SetTextColor(0,100,100,0,false,'');
			}
			
			if($val['nivel'] == 2){
			   $this->Cell(20,3.5, number_format( $val['monto'] , 0 , '.' , ',' ) ,'LT',0,'R');
			   $this->Cell(20,3.5,"",'TR',0,'R');
			}
			else{
				$this->SetFont('','BU',10);
		        $this->Cell(20,3.5, "" ,'LT',0,'R');
				$this->Cell(20,3.5, number_format( $val['monto'] , 0 , '.' , ',' ) ,'TR',0,'R');	
				$this->SetFont('','',9);
			}
			
			$this->ln();	
			$this->SetTextColor(0,-1,-1,-1,false,'');	
			
		}	//Titulos de columnas inferiores 
			//$this->Cell(40,3.5,'','LBR',0,'L');	
			$this->Cell(140,3.5,'','T',0,'L');
			$this->Cell(20,3.5,'','T',0,'R');	
			$this->Cell(20,3.5,'','T',0,'R');					
			$this->ln();
	}

    function generarReporte3C() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		//configuracion de la tabla
		$this->SetFont('','',9);
		
        $tabs = '';
        
        foreach ($this->datos_detalle as $val) {
        	
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
			$this->Cell(140,3.5,$tabs.'('.$val['nro_cuenta'].') '.$val['nombre_cuenta'],'LTR',0,'L');
			
			//si el monto es menor a cero color rojo codigo CMYK
			if($val['monto']*1 < 0){
				$this->SetTextColor(0,100,100,0,false,'');
			}
			
			if($val['nivel'] == 3){
			   $this->Cell(20,3.5, number_format( $val['monto'] , 0 , '.' , ',' ) ,'LT',0,'R');
			   $this->Cell(20,3.5,"",'T',0,'R');
			   $this->Cell(20,3.5,"",'TR',0,'R');
			}
			elseif($val['nivel'] == 2){
			   $this->SetFont('','B',10);
			   $this->Cell(20,3.5,"",'LT',0,'R');
			   $this->Cell(20,3.5, number_format( $val['monto'] , 0 , '.' , ',' ) ,'T',0,'R');
			   $this->Cell(20,3.5,"",'TR',0,'R');
			   $this->SetFont('','',9);
			  
			}
			else{
				$this->SetFont('','BU',11);
		        $this->Cell(20,3.5, "" ,'LT',0,'R');
				$this->Cell(20,3.5,"",'T',0,'R');
				$this->Cell(20,3.5, number_format( $val['monto'] , 0 , '.' , ',' ) ,'TR',0,'R');	
				
				$this->SetFont('','',9);
			}
			//Setea colo dfecto
			$this->SetTextColor(0,-1,-1,-1,false,'');
			
			$this->ln();	
				
			
		}	//Titulos de columnas inferiores 
			//$this->Cell(40,3.5,'','LBR',0,'L');	
			$this->Cell(140,3.5,'','T',0,'L');
			$this->Cell(20,3.5,'','T',0,'R');	
			$this->Cell(20,3.5,'','T',0,'R');
			$this->Cell(20,3.5,'','T',0,'R');						
			$this->ln();
	}  
}
?>

