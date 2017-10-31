<?php
// Extend the TCPDF class to create custom MultiRow
class RLibroMayorXls {
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $s1;
	var $s2;
	var $s3;
	var $s4;
	var $s5;
	var $s6;
	var $t1;
	var $t2;
	var $t3;
	var $t4;
	var $t5;
	var $t6;
	var $total;
	var $datos_entidad;
	var $datos_periodo;
	
	function datosHeader ( $detalle, $totales,$entidad, $periodo) {
        $this->SetHeaderMargin(8);
        $this->SetAutoPageBreak(TRUE, 10);
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->datos_titulo = $totales;
		$this->datos_entidad = $entidad;
		$this->datos_periodo = $periodo;
		$this->subtotal = 0;
		$this->SetMargins(7, 59, 5);
	}
	
	function Header() {
		
		$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
        $black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
        
		
		$this->Ln(3);
		//formato de fecha
		
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 10,5,40,20);
		$this->ln(5);
		
		
	    $this->SetFont('','B',12);		
		$this->Cell(0,5,"LIBRO DE COMPRAS ESTANDAR",0,1,'C');		
		//$this->Ln();
		$this->SetFont('','B',7);
		$this->Cell(0,5,"(Expresado en Bolivianos)",0,1,'C');		
		$this->Ln(2);
		
		$this->SetFont('','',10);
		
		$height = 5;
        $width1 = 5;
		$esp_width = 10;
        $width_c1= 55;
		$width_c2= 112;
        $width3 = 40;
        $width4 = 75;
		
		if($this->objParam->getParametro('filtro_sql') == 'fechas'){
			
			$fecha_ini =$this->objParam->getParametro('fecha_ini');
		    $fecha_fin = $this->objParam->getParametro('fecha_fin');
		
		
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->Cell($width_c1, $height, 'DEL:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->SetFont('', '');
	        $this->SetFillColor(192,192,192, true);
	        $this->Cell($width_c2, $height, $fecha_ini, 0, 0, 'L', true, '', 0, false, 'T', 'C');
	        
	        $this->Cell($esp_width, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->Cell(20, $height,'Haste:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->SetFont('', '');
	        $this->SetFillColor(192,192,192, true);
	        $this->Cell(50, $height, $fecha_fin, 0, 0, 'L', true, '', 0, false, 'T', 'C');
		}
		else{
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->Cell($width_c1, $height, 'Año:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->SetFont('', '');
	        //$this->SetFillColor(192,192,192, true);
	        $this->Cell($width_c2, $height, $this->datos_periodo['gestion'], 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        
	        $this->Cell($esp_width, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->Cell(20, $height,'Mes:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->SetFont('', '');
	        //$this->SetFillColor(192,192,192, true);
	        $this->Cell(50, $height, $this->datos_periodo['literal_periodo'], 0, 0, 'L', false, '', 0, false, 'T', 'C');
		}
		
		
		$this->Ln();
		
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->Cell($width_c1, $height, 'Nombre o Razón Social:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->SetFont('', '');
        $this->SetFillColor(192,192,192, true);
        $this->Cell($width_c2, $height, $this->datos_entidad['nombre'].' ('.$this->datos_entidad['direccion_matriz'].')', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        
        $this->Cell($esp_width, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->Cell(20, $height,'NIT:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->SetFont('', '');
        $this->SetFillColor(192,192,192, true);
        $this->Cell(50, $height, $this->datos_entidad['nit'], 0, 0, 'L', false, '', 0, false, 'T', 'C');
        
		
		$this->Ln(8);
		
		$this->SetFont('','B',6);
		
		
	}
	
	function Footer() {
		
		$this->setY(-15);
		$ormargins = $this->getOriginalMargins();
		$this->SetTextColor(0, 0, 0);
		//set style for cell border
		$line_width = 0.85 / $this->getScaleFactor();
		$this->SetLineStyle(array('width' => $line_width, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
		$ancho = round(($this->getPageWidth() - $ormargins['left'] - $ormargins['right']) / 3);
		$this->Ln(2);
		$cur_y = $this->GetY();
		
		$this->Cell($ancho, 0, '', '', 0, 'L');
		$pagenumtxt = 'Página'.' '.$this->getAliasNumPage().' de '.$this->getAliasNbPages();
		$this->Cell($ancho, 0, $pagenumtxt, '', 0, 'C');
		$this->Cell($ancho, 0, '', '', 0, 'R');
		$this->Ln();
		$fecha_rep = date("d-m-Y H:i:s");
		$this->Cell($ancho, 0, '', '', 0, 'L');
		$this->Ln($line_width);
		
	
	}
	
   
   function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
	    $sw = false;
		$concepto = '';
		
		
		
		
	} 
	


}	
?>