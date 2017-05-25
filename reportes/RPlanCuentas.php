<?php

// Extend the TCPDF class to create custom MultiRow
class RPlanCuentas extends  ReportePDF {
	var $datos_titulo;
	var $datos_detalle;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	
	function datosHeader ( $detalle) {
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->SetMargins(5, 22.5, 5);
	}
	
	function Header() {
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib'.$_SESSION['_DIR_LOGO'], $this->ancho_hoja, 5, 30, 10);
		$this->ln(5);
		$this->SetFont('','BU',12);
		$this->Cell(0,5,'PLAN DE CUENTAS',0,1,'C');
		
		
		$this->Ln(2);
		$this->SetFont('','B',10);
		
		//Titulos de columnas superiores
		$this->Cell(40,3.5,'Códgo Cuenta','LTR',0,'C');
		$this->Cell(150,3.5,'Nombre Cuenta','LTR',0,'C');
		$this->ln();
   }
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
		//configuracion de la tabla
		$this->SetFont('','',9);
        foreach ($this->datos_detalle as $val) {  
	        $this->Cell(40,3.5,$val['nro_cuenta'],'LTR',0,'L');
			$this->Cell(150,3.5,$val['nombre_cuenta'],'LTR',0,'L');
			$this->ln();	
			
		}	//Titulos de columnas inferiores 
			$this->Cell(40,3.5,'','LBR',0,'L');	
			$this->Cell(150,3.5,'','LBR',0,'L');		
			$this->ln();
	} 
}
?>

