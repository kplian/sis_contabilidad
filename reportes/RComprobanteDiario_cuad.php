<?php
// Extend the TCPDF class to create custom MultiRow
class RComprobanteDiario_cuad extends ReportePDF {
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
	var $cant;
	var $valor;
	
	function datosHeader ($detalle,$resultado,$tpoestado,$auxiliar) {
		$this->SetHeaderMargin(10);
		$this->SetAutoPageBreak(TRUE, 10);
		$this->ancho_hoja = $this->getPageWidth()-PDF_MARGIN_LEFT-PDF_MARGIN_RIGHT-10;
		$this->datos_detalle = $detalle;
		$this->datos_titulo = $resultado;
		$this->SetMargins(10, 15, 5,10);
	}
	//
	function getDataSource(){
		return  $this->datos_detalle;		
	}
	//
	function Header() {		
	}
	//	
	function generarCabecera(){
		$conf_par_tablewidths=array(7,15,50,80,20,20);
		$conf_par_tablenumbers=array(0,0,0,0,0,0);
		$conf_par_tablealigns=array('C','C','C','C','C','C');
		$conf_tabletextcolor=array();
		$this->tablewidths=$conf_par_tablewidths;
		$this->tablealigns=$conf_par_tablealigns;
		$this->tablenumbers=$conf_par_tablenumbers;
		$this->tableborders=$conf_tableborders;
		$this->tabletextcolor=$conf_tabletextcolor;
		$valor=$a;
		$var = $this->objParam->getParametro('tipo_moneda');//MT MA MB
		$RowArray = array(
							's0' => 'Nº',
							's1' => 'FECHA',
							's2' => 'DESCRIPCION',
							's3' => 'GLOSA',
							's4' => 'DEBE'."\r\n".$var,
							's5' => 'HABER'."\r\n".$var
						);
		$this->MultiRow($RowArray, false, 1);
	}
	//
	function generarReporte() {
		$this->setFontSubsetting(false);
		$this->AddPage();
		$this->generarCuerpo($this->datos_detalle);
	}
	//		
	function generarCuerpo($detalle){		
		//function
		$this->cab();
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
		$this->imprimirLinea($val,$count,$fill);
	}
	//
	function imprimirLinea($val,$count,$fill){
		$this->SetFillColor(224, 235, 255);
		$this->SetTextColor(0);
		$this->SetFont('','',6);
		$acreedor=0;
		$y=0;
		$sw=0;
		$a=0;
		foreach ($this->getDataSource() as $datarow) {					
			switch ($this->objParam->getParametro('tipo_moneda')) {
				case 'MA':
					$debe=$datarow['importe_debe_ma'];
					$haber=$datarow['importe_haber_ma'];		
					break;
				case 'MT':			
					$debe=$datarow['importe_debe_mt'];
					$haber=$datarow['importe_haber_mt'];
					break;
				case 'MB':
					$debe=$datarow['importe_debe_mb'];
					$haber=$datarow['importe_haber_mb'];			
					break;		
				default:			
					break;
			}				
			//			
			$beneficiario = (int)($this->objParam->getParametro('beneficiario') === 'true');
			$partida = (int)($this->objParam->getParametro('partida') === 'true');			
			$fecha = (int)($this->objParam->getParametro('fecha')=== 'true');
			$nro_comprobante = (int)($this->objParam->getParametro('nro_comprobante')=== 'true');
			$nro_tramite = (int)($this->objParam->getParametro('nro_tramite')=== 'true');			
			$desc_tipo_relacion_comprobante = (int)($this->objParam->getParametro('desc_tipo_relacion_comprobante')=== 'true');					
			$fecIni = (int)($this->objParam->getParametro('fecIni')=== 'true');
			$fecFin = (int)($this->objParam->getParametro('fecFin')=== 'true');	
			$cc = (int)($this->objParam->getParametro('cc')=== 'true');	

			$aux='';
				//
				if($y==0){
					$cab=trim($datarow['nro_cbte']);
					$y++;
				}	
				
				if(trim($datarow['nro_cbte'])==$cab){
					if($sw==0){
						$aux=$aux.'Nro Cbte.:'.trim($datarow['nro_cbte'])."\r\n";
						//					
						if($fecha == 1){
							$arr = explode('-', $datarow['fecha']);
							$newDate = $arr[2].'-'.$arr[1].'-'.$arr[0];
							$aux=$aux.'Fecha:'.$newDate."\r\n";
						}else{
							$aux=$aux.'';
						}
						if($cc == 1){
							$aux=$aux.'Centro de Costo:'.trim($datarow['desc_centro_costo'])."\r\n";			
						}else{			
							$aux=$aux.'';
						}	
						if($nro_tramite == 1){
							$aux=$aux.'Nro Tramite:'.trim($datarow['nro_tramite'])."\r\n";
						}else{
							$aux=$aux.'';
						}		
						if($beneficiario == 1){
							$aux=$aux.'Beneficiario:'.trim($datarow['beneficiario'])."\r\n";			
						}else{			
							$aux=$aux.'';
						}
						if($partida == 1){
							$aux=$aux.'Fecha:'.trim($datarow['partida'])."\r\n";
						}else{
							$aux=$aux.'';
						}										
						if($desc_tipo_relacion_comprobante == 1){
							$aux=$aux.'Tpo. Relacion Cbte.:'.trim(strval($datarow['desc_tipo_relacion_comprobante']))."\r\n";
						}else{
							$aux=$aux.'';
						}	
						$a=0;	
						$sw=1;		
					}else{
						$a=1;
						$aux=$aux.''."\r\n";					
					}				
					
				}else{
					$cab=trim($datarow['nro_cbte']);
					$aux=$aux.'Nro Cbte.:'.trim($datarow['nro_cbte'])."\r\n";				
					//						
					if($fecha == 1){
						$arr = explode('-', $datarow['fecha']);
						$newDate = $arr[2].'-'.$arr[1].'-'.$arr[0];
						$aux=$aux.'Fecha:'.$newDate."\r\n";
					}else{
						$aux=$aux.'';
					}
					if($cc == 1){
						$aux=$aux.'Centro de Costo:'.trim($datarow['desc_centro_costo'])."\r\n";			
					}else{			
						$aux=$aux.'';
					}	
					if($nro_tramite == 1){
						$aux=$aux.'Nro Tramite:'.trim($datarow['nro_tramite'])."\r\n";
					}else{
						$aux=$aux.'';
					}		
					if($beneficiario == 1){
						$aux=$aux.'Beneficiario:'.trim($datarow['beneficiario'])."\r\n";			
					}else{			
						$aux=$aux.'';
					}
					if($partida == 1){
						$aux=$aux.'Fecha:'.trim($datarow['partida'])."\r\n";
					}else{
						$aux=$aux.'';
					}										
					if($desc_tipo_relacion_comprobante == 1){
						$aux=$aux.'Tpo. Relacion Cbte.:'.trim(strval($datarow['desc_tipo_relacion_comprobante']))."\r\n";
					}else{
						$aux=$aux.'';
					}	
					$a=0;											
				}			
						
				if($haber>$debe){
					$m= "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t".trim($datarow['desc_cuenta'])."\r\n".trim($datarow['glosa']);
				}else{
					$m= trim($datarow['desc_cuenta'])."\r\n".trim($datarow['glosa']);
				}
				$arr = explode('-', $datarow['fecha']);
				$newDate = $arr[2].'-'.$arr[1].'-'.$arr[0];
				
				$f = ($this->objParam->getParametro('fecIni'));
				$g = ($this->objParam->getParametro('fecFin'));			
				$f1 = date("d-m-Y", strtotime($f));	
				$f2 = date("d-m-Y", strtotime($g));							
				//
				$this->tablealigns=array('C','L','L','L','R','R');
				$this->tablenumbers=array(0,0,0,0,2,2);
				$this->tableborders=array('RLTB','RLTB','RLTB','RLTB','RLTB','RLTB');
				$this->tabletextcolor=array();	
				//
				if($debe==0 and $haber==0){
				}
				else{
					if($f!=''){
						if($g!=''){
							$time1 = strtotime($f1);
							$time2 = strtotime($f2);
							$time3 = strtotime($newDate);
							if ($time1 < $time3 AND $time2 > $time3){			
								if($a==0){
									$this->SetFont('','B',8);
									$this->tablealigns=array('L','L','R','L','L','L');
									$this->tablenumbers=array(0,0,0,0,0,0);
									$this->tableborders=array('LTB','TB','TB','TB','TB','TBR');
									$RowArray = array(
										's0' => '',
										's1' => '',
										's2' => '-------------'.$newDate,
										's3' => trim($datarow['nro_cbte']).'-------------',
										's4' => '',
										's5' => ''
									);
									$this-> MultiRow($RowArray,$fill,1);
									
									$this->SetTextColor(0);
									$this->SetFont('','',6);
									$this->tablealigns=array('C','L','L','L','R','R');
									$this->tablenumbers=array(0,0,0,0,2,2);
									$this->tableborders=array('RLTB','RLTB','RLTB','RLTB','RLTB','RLTB');
									$this->tabletextcolor=array();							
									$RowArray = array(
										's0' => $i+1,
										's1' => $newDate,
										's2' => $aux,
										's3' => trim($m),
										's4' => $debe,
										's5' => $haber
									);	
									$this-> MultiRow($RowArray,$fill,1);	
								}else{
									$RowArray = array(
										's0' => $i+1,
										's1' => $newDate,
										's2' => $aux,	
										's3' => trim($m), 
										's4' => $debe,
										's5' => $haber
									);	
									$this-> MultiRow($RowArray,$fill,1);
								}
								$fill = !$fill;					
								$this->total = $this->total -1;							
								$i++;					
								$this->revisarfinPagina($datarow);	
							}
						}else{
							$time1 = strtotime($f1);
							$time2 = strtotime($newDate);
							if ($time1 < $time2){			
								if($a==0){
									$this->SetFont('','B',8);
									$this->tablealigns=array('L','L','R','L','L','L');
									$this->tablenumbers=array(0,0,0,0,0,0);
									$this->tableborders=array('LTB','TB','TB','TB','TB','TBR');
									$RowArray = array(
										's0' => '',
										's1' => '',
										's2' => '-------------'.$newDate,
										's3' => trim($datarow['nro_cbte']).'-------------',
										's4' => '',
										's5' => ''
									);
									$this-> MultiRow($RowArray,$fill,1);
									
									$this->SetTextColor(0);
									$this->SetFont('','',6);
									$this->tablealigns=array('C','L','L','L','R','R');
									$this->tablenumbers=array(0,0,0,0,2,2);
									$this->tableborders=array('RLTB','RLTB','RLTB','RLTB','RLTB','RLTB');
									$this->tabletextcolor=array();							
									$RowArray = array(
										's0' => $i+1,
										's1' => $newDate,
										's2' => $aux,
										's3' => trim($m),
										's4' => $debe,
										's5' => $haber
									);	
									$this-> MultiRow($RowArray,$fill,1);	
								}else{
									$RowArray = array(
										's0' => $i+1,
										's1' => $newDate,
										's2' => $aux,	
										's3' => trim($m), 
										's4' => $debe,
										's5' => $haber
									);	
									$this-> MultiRow($RowArray,$fill,1);
								}
								$fill = !$fill;					
								$this->total = $this->total -1;							
								$i++;					
								$this->revisarfinPagina($datarow);	
							}
						}
					}else{
						if($g!=''){
							$time1 = strtotime($f2);
							$time2 = strtotime($newDate);
							if ($time1 > $time2){				
								if($a==0){
									$this->SetFont('','B',8);
									$this->tablealigns=array('L','L','R','L','L','L');
									$this->tablenumbers=array(0,0,0,0,0,0);
									$this->tableborders=array('LTB','TB','TB','TB','TB','TBR');
									$RowArray = array(
										's0' => '',
										's1' => '',
										's2' => '-------------'.$newDate,
										's3' => trim($datarow['nro_cbte']).'-------------',
										's4' => '',
										's5' => ''
									);
									$this-> MultiRow($RowArray,$fill,1);
									
									$this->SetTextColor(0);
									$this->SetFont('','',6);
									$this->tablealigns=array('C','L','L','L','R','R');
									$this->tablenumbers=array(0,0,0,0,2,2);
									$this->tableborders=array('RLTB','RLTB','RLTB','RLTB','RLTB','RLTB');
									$this->tabletextcolor=array();							
									$RowArray = array(
										's0' => $i+1,
										's1' => $newDate,
										's2' => $aux,
										's3' => trim($m),
										's4' => $debe,
										's5' => $haber
									);	
									$this-> MultiRow($RowArray,$fill,1);	
								}else{
									$RowArray = array(
										's0' => $i+1,
										's1' => $newDate,
										's2' => $aux,	
										's3' => trim($m), 
										's4' => $debe,
										's5' => $haber
									);	
									$this-> MultiRow($RowArray,$fill,1);
								}
								$fill = !$fill;					
								$this->total = $this->total -1;							
								$i++;					
								$this->revisarfinPagina($datarow);		
							}
						}else{			
							if($a==0){
								$this->SetFont('','B',8);
								$this->tablealigns=array('L','L','R','L','L','L');
								$this->tablenumbers=array(0,0,0,0,0,0);
								$this->tableborders=array('LTB','TB','TB','TB','TB','TBR');
								$RowArray = array(
									's0' => '',
									's1' => '',
									's2' => '-------------'.$newDate,
									's3' => trim($datarow['nro_cbte']).'-------------',
									's4' => '',
									's5' => ''
								);
								$this-> MultiRow($RowArray,$fill,1);
								
								$this->SetTextColor(0);
								$this->SetFont('','',6);
								$this->tablealigns=array('C','L','L','L','R','R');
								$this->tablenumbers=array(0,0,0,0,2,2);
								$this->tableborders=array('RLTB','RLTB','RLTB','RLTB','RLTB','RLTB');
								$this->tabletextcolor=array();							
								$RowArray = array(
									's0' => $i+1,
									's1' => $newDate,
									's2' => $aux,
									's3' => trim($m),
									's4' => $debe,
									's5' => $haber
								);	
								$this-> MultiRow($RowArray,$fill,1);	
							}else{
								$RowArray = array(
									's0' => $i+1,
									's1' => $newDate,
									's2' => $aux,	
									's3' => trim($m), 
									's4' => $debe,
									's5' => $haber
								);	
								$this-> MultiRow($RowArray,$fill,1);
							}
							$fill = !$fill;					
							$this->total = $this->total -1;							
							$i++;					
							$this->revisarfinPagina($datarow);							
						}
					}	
				}
				//	
			}		
		//								
		$this->cerrarCuadro();
		$this->cerrarCuadroTotal();					
		$this->tablewidths=$conf_par_tablewidths;
		$this->tablealigns=$conf_par_tablealigns;
		$this->tablenumbers=$conf_par_tablenumbers;
		$this->tableborders=$conf_tableborders;
		$this->tabletextcolor=$conf_tabletextcolor;		
	} 
	//
	function revisarfinPagina($a){
		$dimensions = $this->getPageDimensions();
		$hasBorder = false;
		$startY = $this->GetY();
		$this->getNumLines($row['cell1data'], 90);
		$this->calcularMontos($a);			
		if ($startY > 234) {			
			$this->cerrarCuadro();
			$this->cerrarCuadroTotal();		
			if($this->total!= 0){
				$this->AddPage();
				$this->generarCabecera();
			}				
		}
	}
	//
	function calcularMontos($val){
		switch ($this->objParam->getParametro('tipo_moneda')) {
			case 'MA':
				$this->s1 = $this->s1 + $val['importe_debe_ma'];
				$this->s2 = $this->s2 + $val['importe_haber_ma'];		
				break;
			case 'MT':			
				$this->s1 = $this->s1 + $val['importe_debe_mt'];
				$this->s2 = $this->s2 + $val['importe_haber_mt'];
				break;
			case 'MB':
				$this->s1 = $this->s1 + $val['importe_debe_mb'];
				$this->s2 = $this->s2 + $val['importe_haber_mb'];			
				break;		
			default:			
				break;	
		}		
		
		switch ($this->objParam->getParametro('tipo_moneda')) {
			case 'MA':
				$this->t1 = $this->t1 + $val['importe_debe_ma'];
				$this->t2 = $this->t2 + $val['importe_haber_ma'];		
				break;
			case 'MT':			
				$this->t1 = $this->t1 + $val['importe_debe_mt'];
				$this->t2 = $this->t2 + $val['importe_haber_mt'];
				break;
			case 'MB':
				$this->t1 = $this->t1 + $val['importe_debe_mb'];
				$this->t2 = $this->t2 + $val['importe_haber_mb'];			
				break;		
			default:			
				break;	
		}	
	}	
	//revisarfinPagina pie
	function cerrarCuadro(){
		//si noes inicio termina el cuardro anterior
		$conf_par_tablewidths=array(7,15,50,80,20,20);				
		$this->tablealigns=array('R','R','R','R','R','R');		
		$this->tablenumbers=array(0,0,0,0,2,2);
		$this->tableborders=array('T','T','T','T','LRTB','LRTB');								
		$RowArray = array(  's0' => '',
							's1' => '',
							's2' => '', 
							'espacio' => 'Subtotal',
							's3' => $this->s1,
							's4' => $this->s2
						);		
		$this-> MultiRow($RowArray,false,1);
		$this->s1 = 0;
		$this->s2 = 0;
		$this->s3 = 0;
		$this->s4 = 0;
	}
	//revisarfinPagina pie
	function cerrarCuadroTotal(){
		$conf_par_tablewidths=array(7,15,50,80,20,20);			
		$this->tablealigns=array('R','R','R','R','R','R');		
		$this->tablenumbers=array(0,0,0,0,2,2);
		$this->tableborders=array('','','','','LRTB','LRTB');									
		$RowArray = array(
					't0' => '', 
					't1' => '',
					't2' => '',
					'espacio' => 'TOTAL: ',
					't3' => $this->t1,
					't4' => $this->t2
				);
		$this-> MultiRow($RowArray,false,1);	
	}
	//
	function Footer() {		
		$this->setY(-15);
		$ormargins = $this->getOriginalMargins();
		$this->SetTextColor(0, 0, 0);
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
	//
	function cab() {
		$white = array('LTRB' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(255, 255, 255)));
		$black = array('T' =>array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
		$this->Ln(3);
		$this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 10,5,40,20);
		$this->ln(5);
		$this->SetFont('','B',12);		
		$this->Cell(0,5,"LIBRO DIARIO 2",0,1,'C');					
		$this->Ln(3);
		
		$height = 2;
		$width1 = 5;
		$esp_width = 10;
		$width_c1= 30;
		$width_c2= 70;			
		
		if($this->objParam->getParametro('gestion')!=null){
			$gestion = $this->objParam->getParametro('gestion');
			$cant++;	
		}
		if($this->objParam->getParametro('depto')!=null){
			$depto = $this->objParam->getParametro('depto');
			$cant++;	
		}
		//
		$valor =$cant;	
		if($this->objParam->getParametro('gestion')!=null){			
			$gestion=$this->objParam->getParametro('gestion');
			$this->SetFont('', 'B',6);
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');			
			$this->Cell($width_c1, $height, 'Gestion:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->SetFont('', '',6);
			$this->SetFillColor(192,192,192, true);			
			$this->Cell($width_c2, $height, $gestion, 0, 1, 'L', true, '', 0, false, 'T', 'C');	
		}
								
		if($this->objParam->getParametro('depto')!=null){			
			$depto =$this->objParam->getParametro('depto');
			$this->SetFont('', 'B',6);
			$this->Cell($width1, $height, '', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->Cell($width_c1, $height, 'Departamento:', 0, 0, 'L', false, '', 0, false, 'T', 'C');
			$this->SetFont('', '',6);
			$this->SetFillColor(192,192,192, true);			
			$this->Cell($width_c2, $height, $depto, 0, 1, 'L', true, '', 0, false, 'T', 'C');		
		}
		
		$this->Ln(4);
		$this->SetFont('','B',6);
		$this->generarCabecera();
	}		
}
?>