<?php
// Extend the TCPDF class to create custom MultiRow
class RLibroMayorXls extends  ReportePDF {
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
	
	function datosHeader ($detalle,$resultado,$tpoestado,$auxiliar) {
		$this->SetHeaderMargin(20);
		$this->SetAutoPageBreak(TRUE, 10);
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->datos_titulo = $resultado;
		//$this->datos_tpoestado = $tpoestado;
		//$this->datos_auxiliar = $auxiliar;
		$this->subtotal = 0;
		$this->SetMargins(20, 59, 5);
	}
	
	function Header() {
		$this->generarCabecera();
	}
	//	
	function generarCabecera(){
		$conf_par_tablewidths=array(7,80,15,15,15);
		$conf_par_tablealigns=array('C','C','C','C','C');
		$conf_par_tablenumbers=array(0,0,0,0,0);
		$conf_tableborders=array();
		$conf_tabletextcolor=array();
		
		$this->tablewidths=$conf_par_tablewidths;
		$this->tablealigns=$conf_par_tablealigns;
		$this->tablenumbers=$conf_par_tablenumbers;
		$this->tableborders=$conf_tableborders;
		$this->tabletextcolor=$conf_tabletextcolor;

		$RowArray = array(
				's0' => 'Nº',
				's1' => 'NOMBRE ',
				's2' => 'MONTO MB',
				's3' => 'MONTO MT'
				);
		$this->MultiRow($RowArray, false, 1);
	}
}	
?>