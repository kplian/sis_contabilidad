<?php
// Extend the TCPDF class to create custom MultiRow
class RLcvVentas extends  ReportePDF {
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
	var $s7;
	var $s8;
	var $t1;
	var $t2;
	var $t3;
	var $t4;
	var $t5;
	var $t6;
	var $t7;
	var $t8;
	var $total;
	var $datos_entidad;
	var $datos_periodo;
	
	
	
	function datosHeader ( $detalle, $totales,$entidad, $periodo) {
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->datos_titulo = $totales;
		$this->datos_entidad = $entidad;
		$this->datos_periodo = $periodo;
		$this->subtotal = 0;
		$this->SetMargins(7, 55, 5);
	}
	
	function Header() {
		
		$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
        $black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
        
		
		$this->Ln(3);
		//formato de fecha
		$newDate = date("d-m-Y", strtotime($this->objParam->getParametro('hasta')));
		
		//cabecera del reporte
		$this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 10,5,40,20);
		$this->ln(5);
		
		
	    
		
		
	    $this->SetFont('','BU',12);		
		$this->Cell(0,5,"LIBRO DE VENTAS ESTANDAR",0,1,'C');
		$this->SetFont('','BU',7);
		$this->Cell(0,5,"Expresado en Bolivianos",0,1,'C');		
		$this->Ln(2);		
		
		
		$this->SetFont('','',10);
		
		$height = 5;       
        $width1 = 5;
		$esp_width = 10;
        $width_c1= 55;
		$width_c2= 92;
        $width3 = 40;
        $width4 = 75;
		
		
		if($this->objParam->getParametro('filtro_sql') == 'fechas'){
			
			$fecha_ini =$this->objParam->getParametro('fecha_ini');
		    $fecha_fin = $this->objParam->getParametro('fecha_fin');
		
		
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->Cell($width_c1, $height, 'DEL:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->SetFont('', '');
	        $this->SetFillColor(192,192,192, true);
	        $this->Cell($width_c2, $height, $fecha_ini, $black, 0, 'L', true, '', 0, false, 'T', 'C');
	        
	        $this->Cell($esp_width, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->Cell(20, $height,'HASTA:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->SetFont('', '');
	        $this->SetFillColor(192,192,192, true);
	        $this->Cell(50, $height, $fecha_fin, $black, 0, 'L', true, '', 0, false, 'T', 'C');
		}
		else{
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->Cell($width_c1, $height, 'AÑO:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->SetFont('', '');
	        $this->SetFillColor(192,192,192, true);
	        $this->Cell($width_c2, $height, $this->datos_periodo['gestion'], $black, 0, 'L', true, '', 0, false, 'T', 'C');
	        
	        $this->Cell($esp_width, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->Cell(20, $height,'MES:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
	        $this->SetFont('', '');
	        $this->SetFillColor(192,192,192, true);
	        $this->Cell(50, $height, $this->datos_periodo['literal_periodo'], $black, 0, 'L', true, '', 0, false, 'T', 'C');
		}
		
		
		$this->Ln();
		
		$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->Cell($width_c1, $height, 'NOMBRE O RAZON SOCIAL:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->SetFont('', '');
        $this->SetFillColor(192,192,192, true);
        $this->Cell($width_c2, $height, $this->datos_entidad['nombre'].' ('.$this->datos_entidad['direccion_matriz'].')', $black, 0, 'L', true, '', 0, false, 'T', 'C');
        
        $this->Cell($esp_width, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->Cell(20, $height,'NIT:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
        $this->SetFont('', '');
        $this->SetFillColor(192,192,192, true);
        $this->Cell(50, $height, $this->datos_entidad['nit'], $black, 0, 'L', true, '', 0, false, 'T', 'C');
        
		
		
		$this->Ln(8);
		
		$this->SetFont('','B',6);
		$this->generarCabecera();
		
		
	}
   
   function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		
	
		
		$sw = false;
		$concepto = '';
		
		
		
		
		$this->generarCuerpo($this->datos_detalle);
		
		if($this->s1 != 0){
			$this->cerrarCuadro();	
		    $this->cerrarCuadroTotal();
		}
		
		$this->Ln(4);
		
		
	} 
    function generarCabecera(){
    	
		
		
		//armca caecera de la tabla
		$conf_par_tablewidths=array(6,15,15,24,13,19,29,17,16,16,16,16,16,16,16,15);
        $conf_par_tablealigns=array('C','C','C','C','C','C','C','C','C','C','C','C','C','C','C','C');
        $conf_par_tablenumbers=array(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
        $conf_tableborders=array();
        $conf_tabletextcolor=array();
		
		$this->tablewidths=$conf_par_tablewidths;
        $this->tablealigns=$conf_par_tablealigns;
        $this->tablenumbers=$conf_par_tablenumbers;
        $this->tableborders=$conf_tableborders;
        $this->tabletextcolor=$conf_tabletextcolor;
		
		$RowArray = array(
            			's0'  => 'Nº',
                        's1' => 'FECHA DE LA FACTURA', 
                        's2' => 'Nº de LA FACTURA',
                        's3' => 'Nº de AUTORIZACION',          
						's4' => 'ESTADO',
                        's5' => 'NIT CLIENTE',        
                        's6' => 'NOMBRE O RAZON SOCIAL',       
                        's7' => "IMPORTE TOTAL DE LA VENTA\nA",
                        's8' => "IMPORTE ICE/ IEHD/ TASAS\nB",             
                        's9' => "EXPORTACIO. Y OPERACIONES EXENTAS\nC",
                        's10' => "VENTAS GRAVADAS TASA CERO\nD",       
                        's11' => "SUBTOTAL\nE = A-B-C-D",      
                        's12' => "DESCUENTOS BONOS Y REBAJAS OTORGADAS\n F",      
                        's13' => "IMPORTE BASE DEBITO FISCAL\nG = E-F",     
                        's14' => "DEBITO FISCAL\nH = G*13%",     
                        's15' => 'CODIGO DE CONTROL' 
						
						);
                         
        $this-> MultiRow($RowArray,false,1);
		
		
    }
	
	function generarCuerpo($detalle){
		
		$count = 1;
		$sw = 0;
		$ult_region = '';
		$fill = 0;
		
		$this->total = count($detalle);
		
		$this->s1 = 0;
		$this->s2 = 0;
		$this->s3 = 0;
		$this->s4 = 0;
		$this->s5 = 0;
		$this->s6 = 0;
		
		foreach ($detalle as $val) {
			
			$this->imprimirLinea($val,$count,$fill);
			$fill = !$fill;
			$count = $count + 1;
			$this->total = $this->total -1;
			$this->revisarfinPagina();
			
		}
		
		
		
	}	
	
	function imprimirLinea($val,$count,$fill){
		
		$this->SetFillColor(224, 235, 255);
        $this->SetTextColor(0);
        $this->SetFont('','B',6);
			
		$conf_par_tablewidths=array(6,15,15,24,13,19,29,17,16,16,16,16,16,16,16,15);
        $conf_par_tablealigns=array('C','C','C','C','C','C','C','R','R','R','R','R','R','R','R','C');
        $conf_par_tablenumbers=array(0,0,0,0,0,0,0,2,2,2,2,2,2,2,2,0);
		$conf_tableborders=array();//array('LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR','LR');
		
		$this->tablewidths=$conf_par_tablewidths;
        $this->tablealigns=$conf_par_tablealigns;
        $this->tablenumbers=$conf_par_tablenumbers;
        $this->tableborders=$conf_tableborders;
        $this->tabletextcolor=$conf_tabletextcolor;
		
		$this->caclularMontos($val);
		
		$newDate = date("d/m/Y", strtotime( $val['fecha']));
		
		
		$RowArray = array(
            			's0'  => $count,
                        's1' => $newDate, 
                        's2' => $val['nro_documento'],
                        's3' => $val['nro_autorizacion'],          
						's4' => $val['tipo_doc'],
                        's5' => $val['nit'],        
                        's6' => $val['razon_social'],       
                        's7' => $val['importe_doc'],
                        's8' => $val['importe_ice'],             
                        's9' => $val['importe_excento'],
                        's10' => $val['venta_gravada_cero'],       
                        's11' => $val['subtotal_venta'],      
                        's12' => $val['importe_descuento'],      
                        's13' => $val['sujeto_df'],     
                        's14' => $val['importe_iva'],     
                        's15' => $val['codigo_control']);
						
		$this-> MultiRow($RowArray,$fill,1);
			
	}


    function revisarfinPagina(){
		$dimensions = $this->getPageDimensions();
		$hasBorder = false; //flag for fringe case
		
		$startY = $this->GetY();
		$this->getNumLines($row['cell1data'], 80);
		
		if (($startY + 4 * 6) + $dimensions['bm'] > ($dimensions['hk'])) {
		    	
			$this->cerrarCuadro();	
			$this->cerrarCuadroTotal();
			$k = 	($startY + 4 * 6) + $dimensions['bm'] - ($dimensions['hk']);
			
			
			if($this->total!= 0){
				$this->AddPage();
			}
			
			
		    
		} 
		 
		
	}
	
	
	
	function caclularMontos($val){
		
		$this->s1 = $this->s1 + $val['importe_doc'];
		$this->s2 = $this->s2 + $val['importe_ice'];
		$this->s3 = $this->s3 + $val['importe_excento'];
		$this->s4 = $this->s4 + $val['venta_gravada_cero'];
		$this->s5 = $this->s5 + $val['subtotal_venta'];
		$this->s6 = $this->s6 + $val['importe_descuento'];
		$this->s7 = $this->s7 + $val['sujeto_df'];
		$this->s8 = $this->s8 + $val['importe_iva'];
		
		
		$this->t1 = $this->t1 + $val['importe_doc'];
		$this->t2 = $this->t2 + $val['importe_ice'];
		$this->t3 = $this->t3 + $val['importe_excento'];
		$this->t4 = $this->t4 + $val['venta_gravada_cero'];
		$this->t5 = $this->t5 + $val['subtotal_venta'];
		$this->t6 = $this->t6 + $val['importe_descuento'];
		$this->t7 = $this->t7 + $val['sujeto_df'];
		$this->t8 = $this->t8 + $val['importe_iva'];
		
		
		
	}
  function cerrarCuadro(){
  	
	   
	   	    //si noes inicio termina el cuardro anterior
	   	  $conf_par_tablewidths=array(6+15+15+24+13+19+29,17,16,16,16,16,16,16,16);
          $conf_par_tablealigns=array('R','R','R','R','R','R','R','R','R');
          $conf_par_tablenumbers=array(0,2,2,2,2,2,2,2,2);
		  $conf_par_tableborders=array('T','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB');
			
			
			//coloca el total de egresos
			//coloca el total de la partida 
	        $this->tablewidths=$conf_par_tablewidths;
	        $this->tablealigns=$conf_par_tablealigns;
	        $this->tablenumbers=$conf_par_tablenumbers;
	        $this->tableborders=$conf_par_tableborders;
	        
	        $RowArray = array( 
	                    'espacio' => 'Subtotal: ',
	                    's1' => $this->s1,
	                    's2' => $this->s2,
	                    's3' => $this->s3,
	                    's4' => $this->s4,
	                    's5' => $this->s5,
	                    's6' => $this->s6,
	                    's7' => $this->s7,
	                    's8' => $this->s8
	                  );     
	                     
	        $this-> MultiRow($RowArray,false,1);
			
			$this->s1 = 0;
			$this->s2 = 0;
			$this->s3 = 0;
			$this->s4 = 0;
			$this->s5 = 0;
			$this->s6 = 0;
			$this->s7 = 0;
			$this->s8 = 0;
	
	
  }

  function cerrarCuadroTotal(){
  	
	   
	   	    //si noes inicio termina el cuardro anterior
	   	  
			
		  $conf_par_tablewidths=array(6+15+15+24+13+19+29,17,16,16,16,16,16,16,16);
          $conf_par_tablealigns=array('R','R','R','R','R','R','R','R','R');
          $conf_par_tablenumbers=array(0,2,2,2,2,2,2,2,2);
		  $conf_par_tableborders=array('T','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB');
			
			//coloca el total de egresos
			//coloca el total de la partida 
	        $this->tablewidths=$conf_par_tablewidths;
	        $this->tablealigns=$conf_par_tablealigns;
	        $this->tablenumbers=$conf_par_tablenumbers;
	        $this->tableborders=$conf_par_tableborders;
	        
	        $RowArray = array( 
	                    'espacio' => 'TOTAL: ',
	                    't1' => $this->t1,
	                    't2' => $this->t2,
	                    't3' => $this->t3,
	                    't4' => $this->t4,
	                    't5' => $this->t5,
	                    't6' => $this->t6,
	                    't7' => $this->t7,
	                    't8' => $this->t8
	                  );     
	                     
	        $this-> MultiRow($RowArray,false,1);
	
  }
  
 
}
?>