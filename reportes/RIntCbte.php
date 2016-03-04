<?php
// Extend the TCPDF class to create custom MultiRow
class RIntCbte extends  ReportePDF {
	var $cabecera;
	var $detalleCbte;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $total;
	var $with_col;
	var $tot_debe;
	var $tot_haber;
	var $tot_debe_mb;
	var $tot_haber_mb;
	
	function datosHeader ( $detalle) {
		
		$this->cabecera = $detalle->getParameter('cabecera');
        $this->detalleCbte = $detalle->getParameter('detalleCbte');
		
		$this->ancho_hoja = $this->getPageWidth() - PDF_MARGIN_LEFT - PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
	    $this->SetMargins(15, 70, 5);
	}
	
	function Header() {
			
		
		$newDate = date("d/m/Y", strtotime( $this->cabecera[0]['fecha']));		
		$dataSource = $this->datos_detalle; 
	    ob_start();
		include(dirname(__FILE__).'/../reportes/tpl/cabecera.php');
        $content = ob_get_clean();
		$this->writeHTML($content, true, false, true, false, '');
		
		
		
	}
	
	
   
   function generarReporteooo() {
		// get the HTML
		$dataSource = $this->datos_detalle; 
	    ob_start();		
	    include(dirname(__FILE__).'/../reportes/tpl/intCbte.php');
        $content = ob_get_clean();
		
		$this->AddPage();
	    $this->writeHTML($content, true, false, true, false, '');
		$this->revisarfinPagina();
		
		$this->Firmas();	
		
	} 
   
  
	
	 function generarReporte() {
	 	
		$this->AddPage();
		
		$dataSource = $this->datos_detalle; 
		$tot_debe = 0;
		$tot_haber = 0;
		if ($this->cabecera[0]['id_moneda'] == $this->cabecera[0]['id_moneda_base']){
		    $this->with_col = '60%';
	    }
	    else{
		   $this->with_col = '50%';
	    }
		
		$with_col = $this->with_col;
		
		foreach($this->detalleCbte as $key=>$val){
		   	
		   $sw = 1;	
		   if ($this->cabecera[0]['id_moneda'] == $this->cabecera[0]['id_moneda_base'] &&  $val['importe_debe'] == 0 && $val['importe_haber'] == 0){
				$sw = 0;	
		   }
		   	
		   if ($sw == 1){ 		
		    	ob_start();
			    include(dirname(__FILE__).'/../reportes/tpl/transaccion.php');
	            $content = ob_get_clean();
				$this->writeHTML($content, false, false, true, false, '');
				
				
				$this->tot_debe+=$val['importe_debe'];
				$this->tot_haber+=$val['importe_haber'];
				$this->tot_debe_mb+=$val['importe_debe_mb'];
				$this->tot_haber_mb+=$val['importe_haber_mb'];
				
				$this->revisarfinPagina();
				
		    }	
			
		}
		//ob_start();
		// $content = ob_get_clean();
		//$this->writeHTML($content, true, false, true, false, '');
		
		$this->Ln();
	    $this->subtotales('TOTALES');	
		
		$this->Ln(2);
		$this->Firmas();
		
		  	
		
	} 

   function Firmas() {
			
		
		$newDate = date("d/m/Y", strtotime( $this->cabecera[0]['fecha']));		
		$dataSource = $this->datos_detalle; 
	    ob_start();
		include(dirname(__FILE__).'/../reportes/tpl/firmas.php');
        $content = ob_get_clean();
		$this->writeHTML($content, true, false, true, false, '');
		
		
		
	}

   function subtotales ($titulo){
   	  ob_start();
	  include(dirname(__FILE__).'/../reportes/tpl/totales.php');
      $content = ob_get_clean();
	  $this->writeHTML($content, false, false, true, false, '');
	
   }
	
	
   function revisarfinPagina(){
		$dimensions = $this->getPageDimensions();
		$hasBorder = false; //flag for fringe case
		
		$startY = $this->GetY();
		$this->getNumLines($row['cell1data'], 80);
		
		//if (($startY + 10 * 6) + $dimensions['bm'] > ($dimensions['hk'])) {
		    
		if ($startY > 220) {
			$this->Ln();
			$this->subtotales('Pasa a la siguiente página');			
			$this->AddPage();		    
		} 
	}
}
?>