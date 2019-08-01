<?php
/**
*@package pXP
*@file gen-ACTIntTransaccion.php
*@author  (admin)
*@date 01-09-2013 18:10:12
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
/**
HISTORIAL DE MODIFICACIONES:
ISSUE 		   FECHA   			 AUTOR				 DESCRIPCION:
#2         19/12/2108		  Miguel Mamani	  reporte proyectos excel
#92 		 19/12/2108		  Miguel Mamani	  actualización reporte de detalle de auxiliares
#5			24/12/2108		  Manuel Guerra	  Correcion de sumas en auxiliares
#6			27/12/2108		  Manuel Guerra	  Agregar filtro de cbtes de cierre
#17 		09/01/2019		  Manuel Guerra	  agrego el filtro de nro_tramite_aux
 */
require_once(dirname(__FILE__).'/../reportes/RTransaccionmayor.php');
require_once(dirname(__FILE__).'/../reportes/RTransaccionmayorSaldo.php');
require_once(dirname(__FILE__).'/../reportes/RMayorXls.php');
include_once(dirname(__FILE__).'/../../lib/lib_general/ExcelInput.php');
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once(dirname(__FILE__).'/../reportes/RAuxliarTramitesXls.php'); //#92
require_once(dirname(__FILE__).'/../reportes/RProyectosArbol.php');//#2
require_once(dirname(__FILE__).'/../reportes/RIntTransaccionMayorExcel.php');//#2


class ACTIntTransaccion extends ACTbase{
			
	function listarIntTransaccion(){
		$this->objParam->defecto('ordenacion','orden');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_int_comprobante')!=''){
			$this->objParam->addFiltro("transa.id_int_comprobante = ".$this->objParam->getParametro('id_int_comprobante'));	
		}
		
		
		if($this->objParam->getParametro('id_int_comprobante_fks')!=''){
			$this->objParam->addFiltro("transa.id_int_comprobante in (".$this->objParam->getParametro('id_int_comprobante_fks').")");	
		}
		else{
			if($this->objParam->getParametro('forzar_relacion')=='si'){
				 throw new Exception("Primero defina con que comprobante esta relacionado", 3);
				 $this->objParam->addFiltro("transa.id_int_comprobante in (0)");	
		
			}
		}
		
		if($this->objParam->getParametro('solo_debe')=='si'){
			$this->objParam->addFiltro("transa.importe_debe > 0 ");	
		}
		
		if($this->objParam->getParametro('solo_haber')=='si'){
			$this->objParam->addFiltro("transa.importe_haber > 0 ");	
		}
		
		if($this->objParam->getParametro('solo_gasto_recurso') == 'si'){
			$this->objParam->addFiltro("par.tipo in (''recurso'',''gasto'')");	
		}
		
		if($this->objParam->getParametro('pres_gasto_recurso') == 'si'){
			$this->objParam->addFiltro("cc.movimiento_tipo_pres in (''gasto'',''recurso'')");	
		}

         if($this->objParam->getParametro('pres_adm') == 'si'){
			$this->objParam->addFiltro("cc.movimiento_tipo_pres in (''administrativo'')");	
		}

		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODIntTransaccion','listarIntTransaccion');
		} else{
			$this->objFunc=$this->create('MODIntTransaccion');
			
			$this->res=$this->objFunc->listarIntTransaccion($this->objParam);
		}
		
		if($this->objParam->getParametro('resumen')!='no'){
			//adicionar una fila al resultado con el summario
			$temp = Array();
			$temp['importe_debe'] = $this->res->extraData['total_debe'];
			$temp['importe_haber'] = $this->res->extraData['total_haber'];
			$temp['importe_debe_mb'] = $this->res->extraData['total_debe_mb'];
			$temp['importe_haber_mb'] = $this->res->extraData['total_haber_mb'];
			$temp['importe_debe_mt'] = $this->res->extraData['total_debe_mt'];
			$temp['importe_haber_mt'] = $this->res->extraData['total_haber_mt'];			
			$temp['importe_debe_ma'] = $this->res->extraData['total_debe_ma'];
			$temp['importe_haber_ma'] = $this->res->extraData['total_haber_ma'];
			$temp['importe_gasto'] = $this->res->extraData['total_gasto'];
			$temp['importe_recurso'] = $this->res->extraData['total_recurso'];
			$temp['glosa'] = 'Sumas iguales';
			$temp['tipo_reg'] = 'summary';
			$temp['id_int_transaccion'] = 0;
			
			$this->res->total++;
			
			$this->res->addLastRecDatos($temp);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarIntTransaccion(){
		$this->objFunc=$this->create('MODIntTransaccion');	
		if($this->objParam->insertar('id_int_transaccion')){
			$this->res=$this->objFunc->insertarIntTransaccion($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarIntTransaccion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarIntTransaccion(){
			$this->objFunc=$this->create('MODIntTransaccion');	
		$this->res=$this->objFunc->eliminarIntTransaccion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarIntTransaccionMayor(){
		$this->objParam->defecto('ordenacion','id_int_transaccion');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_int_comprobante')!=''){
			$this->objParam->addFiltro("transa.id_int_comprobante = ".$this->objParam->getParametro('id_int_comprobante'));	
		}
		
		
		if($this->objParam->getParametro('id_gestion')!=''){
			$this->objParam->addFiltro("per.id_gestion = ".$this->objParam->getParametro('id_gestion'));	
		}
		
		if($this->objParam->getParametro('id_config_tipo_cuenta')!=''){
			$this->objParam->addFiltro("ctc.id_config_tipo_cuenta = ".$this->objParam->getParametro('id_config_tipo_cuenta'));	
		}
		
		if($this->objParam->getParametro('id_config_subtipo_cuenta')!=''){
			$this->objParam->addFiltro("csc.id_config_subtipo_cuenta = ".$this->objParam->getParametro('id_config_subtipo_cuenta'));	
		}
		
		
		if($this->objParam->getParametro('id_depto')!=''){
			$this->objParam->addFiltro("icbte.id_depto = ".$this->objParam->getParametro('id_depto'));	
		}
		#6
		if($this->objParam->getParametro('cbte_cierre')=='todos'){			
			$this->objParam->addFiltro("icbte.cbte_cierre in (''no'',''balance'',''resultado'')");
		}else{
			if($this->objParam->getParametro('cbte_cierre')=='balance'){
				$this->objParam->addFiltro("icbte.cbte_cierre in (''balance'')");
			}else{
				if($this->objParam->getParametro('cbte_cierre')=='resultado'){
					$this->objParam->addFiltro("icbte.cbte_cierre in (''resultado'')");
				}else{
					if($this->objParam->getParametro('cbte_cierre')=='no'){
						$this->objParam->addFiltro("icbte.cbte_cierre in (''no'')");
					}
				}						
			}		
		}
		 
		if($this->objParam->getParametro('id_partida')!=''){
			$this->objParam->addFiltro("transa.id_partida = ".$this->objParam->getParametro('id_partida'));	
		}
		
		if($this->objParam->getParametro('id_suborden')!=''){
			$this->objParam->addFiltro("transa.id_subordeno = ".$this->objParam->getParametro('id_suborden'));	
		}
		
		
		if($this->objParam->getParametro('id_auxiliar')!=''){
			$this->objParam->addFiltro("transa.id_auxiliar = ".$this->objParam->getParametro('id_auxiliar'));	
		}
		
		if($this->objParam->getParametro('id_centro_costo')!=''){
			$this->objParam->addFiltro("transa.id_centro_costo = ".$this->objParam->getParametro('id_centro_costo'));	
		}
		
		if($this->objParam->getParametro('nro_tramite')!=''){
			$this->objParam->addFiltro("icbte.nro_tramite ilike ''%".$this->objParam->getParametro('nro_tramite')."%''");	
		}
		#17
		if($this->objParam->getParametro('nro_tramite_aux')!=''){
			$this->objParam->addFiltro("icbte.nro_tramite_aux ilike ''%".$this->objParam->getParametro('nro_tramite_aux')."%''");	
		}
		
		if($this->objParam->getParametro('cerrado')=='si'){
			$this->objParam->addFiltro("transa.cerrado in (''no'')");
		}else{
			$this->objParam->addFiltro("transa.cerrado in (''si'',''no'')");
		}
		if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')!=''){
			$this->objParam->addFiltro("(icbte.fecha::date  BETWEEN ''%".$this->objParam->getParametro('desde')."%''::date  and ''%".$this->objParam->getParametro('hasta')."%''::date)");	
		}
		
		if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')==''){
			$this->objParam->addFiltro("(icbte.fecha::date  >= ''%".$this->objParam->getParametro('desde')."%''::date)");	
		}
		
		if($this->objParam->getParametro('desde')=='' && $this->objParam->getParametro('hasta')!=''){
			$this->objParam->addFiltro("(icbte.fecha::date  <= ''%".$this->objParam->getParametro('hasta')."%''::date)");	
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODIntTransaccion','listarIntTransaccionMayor');
		} else{
			$this->objFunc=$this->create('MODIntTransaccion');
			
			$this->res=$this->objFunc->listarIntTransaccionMayor($this->objParam);
		}
		//adicionar una fila al resultado con el summario
		$temp = Array();
		$temp['importe_debe_mb'] = $this->res->extraData['total_debe'];
		$temp['importe_haber_mb'] = $this->res->extraData['total_haber'];
		$temp['importe_debe_mt'] = $this->res->extraData['total_debe_mt'];
		$temp['importe_haber_mt'] = $this->res->extraData['total_haber_mt'];		
		$temp['importe_debe_ma'] = $this->res->extraData['total_debe_ma'];
		$temp['importe_haber_ma'] = $this->res->extraData['total_haber_ma'];
		
		$temp['saldo_mb'] = $this->res->extraData['total_saldo_mb'];
		$temp['saldo_mt'] = $this->res->extraData['total_saldo_mt'];
		$temp['dif'] = $this->res->extraData['dif'];
		
		$temp['tipo_reg'] = 'summary';
		$temp['id_int_transaccion'] = 0;
				
		$this->res->total++;
		
		$this->res->addLastRecDatos($temp);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}


    function guardarDatosBancos(){
		$this->objFunc=$this->create('MODIntTransaccion');	
		if($this->objParam->insertar('id_int_transaccion')){
			$this->res=$this->objFunc->guardarDatosBancos($this->objParam);			
		} else{			
			$this->res=$this->objFunc->guardarDatosBancos($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

     function listarIntTransaccionOrden(){
		$this->objParam->defecto('ordenacion','id_orden_trabajo');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODIntTransaccion','listarIntTransaccionOrden');
		} else{
			$this->objFunc=$this->create('MODIntTransaccion');
			
			$this->res=$this->objFunc->listarIntTransaccionOrden($this->objParam);
		}
		//adicionar una fila al resultado con el summario
		$temp = Array();
		$temp['importe_debe_mb'] = $this->res->extraData['total_debe'];
		$temp['importe_haber_mb'] = $this->res->extraData['total_haber'];
		$temp['importe_debe_mt'] = $this->res->extraData['total_debe_mt'];
		$temp['importe_haber_mt'] = $this->res->extraData['total_haber_mt'];
		$temp['importe_debe_ma'] = $this->res->extraData['total_debe_ma'];
		$temp['importe_haber_ma'] = $this->res->extraData['total_haber_ma'];
		$temp['tipo_reg'] = 'summary';
		$temp['id_orden_trabajo'] = -1;
		
		$this->res->total++;
		
		$this->res->addLastRecDatos($temp);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    function listarIntTransaccionPartida(){
		$this->objParam->defecto('ordenacion','codigo_partida');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODIntTransaccion','listarIntTransaccionPartida');
		} else{
			$this->objFunc=$this->create('MODIntTransaccion');
			
			$this->res=$this->objFunc->listarIntTransaccionPartida($this->objParam);
		}
		//adicionar una fila al resultado con el summario
		$temp = Array();
		$temp['importe_debe_mb'] = $this->res->extraData['total_debe'];
		$temp['importe_haber_mb'] = $this->res->extraData['total_haber'];
		$temp['importe_debe_mt'] = $this->res->extraData['total_debe_mt'];
		$temp['importe_haber_mt'] = $this->res->extraData['total_haber_mt'];
		$temp['importe_debe_ma'] = $this->res->extraData['total_debe_ma'];
		$temp['importe_haber_ma'] = $this->res->extraData['total_haber_ma'];
		$temp['tipo_reg'] = 'summary';
		$temp['tipo_reg'] = 'summary';
		$temp['id_partida'] = -1;
		
		$this->res->total++;
		
		$this->res->addLastRecDatos($temp);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    function listarIntTransaccionCuenta(){
		$this->objParam->defecto('ordenacion','codigo_partida');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODIntTransaccion','listarIntTransaccionCuenta');
		} else{
			$this->objFunc=$this->create('MODIntTransaccion');
			
			$this->res=$this->objFunc->listarIntTransaccionCuenta($this->objParam);
		}
		//adicionar una fila al resultado con el summario
		$temp = Array();
		$temp['importe_debe_mb'] = $this->res->extraData['total_debe'];
		$temp['importe_haber_mb'] = $this->res->extraData['total_haber'];
		$temp['importe_debe_mt'] = $this->res->extraData['total_debe_mt'];
		$temp['importe_haber_mt'] = $this->res->extraData['total_haber_mt'];
		$temp['importe_debe_ma'] = $this->res->extraData['total_debe_ma'];
		$temp['importe_haber_ma'] = $this->res->extraData['total_haber_ma'];
		$temp['tipo_reg'] = 'summary';
		$temp['id_cuenta'] = -1;
		
		$this->res->total++;
		
		$this->res->addLastRecDatos($temp);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	//
	function listarIntTransaccionMayorReporte(){		
		if($this->objParam->getParametro('id_int_comprobante')!=''){
			$this->objParam->addFiltro("transa.id_int_comprobante = ".$this->objParam->getParametro('id_int_comprobante'));	
		}
		if($this->objParam->getParametro('id_gestion')!=''){
			$this->objParam->addFiltro("per.id_gestion = ".$this->objParam->getParametro('id_gestion'));	
		}		
		if($this->objParam->getParametro('id_config_tipo_cuenta')!=''){
			$this->objParam->addFiltro("ctc.id_config_tipo_cuenta = ".$this->objParam->getParametro('id_config_tipo_cuenta'));	
		}		
		if($this->objParam->getParametro('id_config_subtipo_cuenta')!=''){
			$this->objParam->addFiltro("csc.id_config_subtipo_cuenta = ".$this->objParam->getParametro('id_config_subtipo_cuenta'));	
		}
		if($this->objParam->getParametro('id_depto')!=''){
			$this->objParam->addFiltro("icbte.id_depto = ".$this->objParam->getParametro('id_depto'));	
		}	
		if($this->objParam->getParametro('id_partida')!=''){
			$this->objParam->addFiltro("transa.id_partida = ".$this->objParam->getParametro('id_partida'));	
		}		
		if($this->objParam->getParametro('id_suborden')!=''){
			$this->objParam->addFiltro("transa.id_subordeno = ".$this->objParam->getParametro('id_suborden'));	
		}
		if($this->objParam->getParametro('id_auxiliar')!=''){
			$this->objParam->addFiltro("transa.id_auxiliar = ".$this->objParam->getParametro('id_auxiliar'));	
		}		
		if($this->objParam->getParametro('id_centro_costo')!=''){
			$this->objParam->addFiltro("transa.id_centro_costo = ".$this->objParam->getParametro('id_centro_costo'));	
		}		
		if($this->objParam->getParametro('nro_tramite')!=''){
			$this->objParam->addFiltro("icbte.nro_tramite ilike ''%".$this->objParam->getParametro('nro_tramite')."%''");	
		}
		if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')!=''){
			$this->objParam->addFiltro("(icbte.fecha::date  BETWEEN ''%".$this->objParam->getParametro('desde')."%''::date  and ''%".$this->objParam->getParametro('hasta')."%''::date)");	
		}		
		if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')==''){
			$this->objParam->addFiltro("(icbte.fecha::date  >= ''%".$this->objParam->getParametro('desde')."%''::date)");	
		}		
		if($this->objParam->getParametro('desde')=='' && $this->objParam->getParametro('hasta')!=''){
			$this->objParam->addFiltro("(icbte.fecha::date  <= ''%".$this->objParam->getParametro('hasta')."%''::date)");	
		}
		$this->objFunc=$this->create('MODIntTransaccion');								
		$cbteHeader = $this->objFunc->listarIntTransaccionRepMayor($this->objParam);
				
		if($cbteHeader->getTipo() == 'EXITO'){										
			return $cbteHeader;			
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}		
	}
	function listarIntTransaccionMayorSaldo(){		
		if($this->objParam->getParametro('id_int_comprobante')!=''){
			$this->objParam->addFiltro("transa.id_int_comprobante = ".$this->objParam->getParametro('id_int_comprobante'));	
		}
		if($this->objParam->getParametro('id_gestion')!=''){
			$this->objParam->addFiltro("per.id_gestion = ".$this->objParam->getParametro('id_gestion'));	
		}		
		if($this->objParam->getParametro('id_config_tipo_cuenta')!=''){
			$this->objParam->addFiltro("ctc.id_config_tipo_cuenta = ".$this->objParam->getParametro('id_config_tipo_cuenta'));	
		}		
		if($this->objParam->getParametro('id_config_subtipo_cuenta')!=''){
			$this->objParam->addFiltro("csc.id_config_subtipo_cuenta = ".$this->objParam->getParametro('id_config_subtipo_cuenta'));	
		}
		if($this->objParam->getParametro('id_depto')!=''){
			$this->objParam->addFiltro("icbte.id_depto = ".$this->objParam->getParametro('id_depto'));	
		}	
		if($this->objParam->getParametro('id_partida')!=''){
			$this->objParam->addFiltro("transa.id_partida = ".$this->objParam->getParametro('id_partida'));	
		}		
		if($this->objParam->getParametro('id_suborden')!=''){
			$this->objParam->addFiltro("transa.id_subordeno = ".$this->objParam->getParametro('id_suborden'));	
		}
		if($this->objParam->getParametro('id_auxiliar')!=''){
			$this->objParam->addFiltro("transa.id_auxiliar = ".$this->objParam->getParametro('id_auxiliar'));	
		}		
		if($this->objParam->getParametro('id_centro_costo')!=''){
			$this->objParam->addFiltro("transa.id_centro_costo = ".$this->objParam->getParametro('id_centro_costo'));	
		}		
		if($this->objParam->getParametro('nro_tramite')!=''){
			$this->objParam->addFiltro("icbte.nro_tramite ilike ''%".$this->objParam->getParametro('nro_tramite')."%''");	
		}
		if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')!=''){
			$this->objParam->addFiltro("(icbte.fecha::date  BETWEEN ''%".$this->objParam->getParametro('desde')."%''::date  and ''%".$this->objParam->getParametro('hasta')."%''::date)");	
		}		
		if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')==''){
			$this->objParam->addFiltro("(icbte.fecha::date  >= ''%".$this->objParam->getParametro('desde')."%''::date)");	
		}		
		if($this->objParam->getParametro('desde')=='' && $this->objParam->getParametro('hasta')!=''){
			$this->objParam->addFiltro("(icbte.fecha::date  <= ''%".$this->objParam->getParametro('hasta')."%''::date)");	
		}
		$this->objFunc=$this->create('MODIntTransaccion');								
		$cbteHeader = $this->objFunc->listarMayorSaldo($this->objParam);
				
		if($cbteHeader->getTipo() == 'EXITO'){										
			return $cbteHeader;			
		}
		else{
			$cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}		
	}	
	//mp
	function impReporteMayor() {
		if($this->objParam->getParametro('tipo_formato')=='pdf') {
			$nombreArchivo = uniqid(md5(session_id()).'LibroMayor').'.pdf';			
			$dataSource = $this->listarIntTransaccionMayorReporte();
			$dataEntidad = "";
			$dataPeriodo = "";	
			$orientacion = 'P';		
			$tamano = 'LETTER';
			$titulo = 'Consolidado';
			$this->objParam->addParametro('orientacion',$orientacion);
			$this->objParam->addParametro('tamano',$tamano);		
			$this->objParam->addParametro('titulo_archivo',$titulo);	
			$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
			$reporte = new RTransaccionmayor($this->objParam);  
			$reporte->datosHeader($dataSource->getDatos(),$dataSource->extraData, '' , '');		
			$reporte->generarReporte();
			$reporte->output($reporte->url_archivo,'F');
			$this->mensajeExito=new Mensaje();
			$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genera con exito el reporte: '.$nombreArchivo,'control');
			$this->mensajeExito->setArchivoGenerado($nombreArchivo);
			$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());		
		}
		if($this->objParam->getParametro('tipo_formato')=='xls') {
			if($this->objParam->getParametro('id_int_comprobante')!=''){
				$this->objParam->addFiltro("transa.id_int_comprobante = ".$this->objParam->getParametro('id_int_comprobante'));	
			}
			if($this->objParam->getParametro('id_gestion')!=''){
				$this->objParam->addFiltro("per.id_gestion = ".$this->objParam->getParametro('id_gestion'));	
			}		
			if($this->objParam->getParametro('id_config_tipo_cuenta')!=''){
				$this->objParam->addFiltro("ctc.id_config_tipo_cuenta = ".$this->objParam->getParametro('id_config_tipo_cuenta'));	
			}		
			if($this->objParam->getParametro('id_config_subtipo_cuenta')!=''){
				$this->objParam->addFiltro("csc.id_config_subtipo_cuenta = ".$this->objParam->getParametro('id_config_subtipo_cuenta'));	
			}
			if($this->objParam->getParametro('id_depto')!=''){
				$this->objParam->addFiltro("icbte.id_depto = ".$this->objParam->getParametro('id_depto'));	
			}	
			if($this->objParam->getParametro('id_partida')!=''){
				$this->objParam->addFiltro("transa.id_partida = ".$this->objParam->getParametro('id_partida'));	
			}		
			if($this->objParam->getParametro('id_suborden')!=''){
				$this->objParam->addFiltro("transa.id_subordeno = ".$this->objParam->getParametro('id_suborden'));	
			}
			if($this->objParam->getParametro('id_auxiliar')!=''){
				$this->objParam->addFiltro("transa.id_auxiliar = ".$this->objParam->getParametro('id_auxiliar'));	
			}		
			if($this->objParam->getParametro('id_centro_costo')!=''){
				$this->objParam->addFiltro("transa.id_centro_costo = ".$this->objParam->getParametro('id_centro_costo'));	
			}		
			if($this->objParam->getParametro('nro_tramite')!=''){
				$this->objParam->addFiltro("icbte.nro_tramite ilike ''%".$this->objParam->getParametro('nro_tramite')."%''");	
			}
			if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')!=''){
				$this->objParam->addFiltro("(icbte.fecha::date  BETWEEN ''%".$this->objParam->getParametro('desde')."%''::date  and ''%".$this->objParam->getParametro('hasta')."%''::date)");	
			}		
			if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')==''){
				$this->objParam->addFiltro("(icbte.fecha::date  >= ''%".$this->objParam->getParametro('desde')."%''::date)");	
			}		
			if($this->objParam->getParametro('desde')=='' && $this->objParam->getParametro('hasta')!=''){
				$this->objParam->addFiltro("(icbte.fecha::date  <= ''%".$this->objParam->getParametro('hasta')."%''::date)");	
			}				
			$this->objFun=$this->create('MODIntTransaccion');	
			$this->res = $this->objFun->listarIntTransaccionRepMayor();	
			if($this->res->getTipo()=='ERROR'){
				$this->res->imprimirRespuesta($this->res->generarJson());
				exit;
			}		
			$titulo ='Ret';
			$nombreArchivo=uniqid(md5(session_id()).$titulo);
			$nombreArchivo.='.xls';
			$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
			$this->objParam->addParametro('datos',$this->res->datos);
						
			$this->objReporteFormato=new RMayorXls($this->objParam);
			$this->objReporteFormato->generarDatos();
			$this->objReporteFormato->generarReporte();
			$this->mensajeExito=new Mensaje();
			$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con éxito el reporte: '.$nombreArchivo,'control');
			$this->mensajeExito->setArchivoGenerado($nombreArchivo);
			$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
		}					
	}

	function SubirArchivoTran(){
        $arregloFiles = $this->objParam->getArregloFiles();
        $ext = pathinfo($arregloFiles['archivo']['name']);
        $extension = $ext['extension'];
        $error = 'no';
        $mensaje_completo = '';
        
        if(isset($arregloFiles['archivo']) && is_uploaded_file($arregloFiles['archivo']['tmp_name'])) {
            if (!in_array($extension, array('xls', 'xlsx', 'XLS', 'XLSX'))) {
                $mensaje_completo = "La extensión del archivo debe ser XLS o XLSX";
                $error = 'error_fatal';
            } else {
                //procesa Archivo
                $archivoExcel = new ExcelInput($arregloFiles['archivo']['tmp_name'], 'IMPTRACON');
                $archivoExcel->recuperarColumnasExcel();
                $arrayArchivo = $archivoExcel->leerColumnasArchivoExcel();
                foreach ($arrayArchivo as $fila) {
                	//var_dump($fila)	;echo"<br>";				
                    $this->objParam->addParametro('centro_costo', $fila['centro_costo']);
                    $this->objParam->addParametro('partida', $fila['partida']);
                    $this->objParam->addParametro('cuenta', $fila['cuenta']);
                    $this->objParam->addParametro('auxiliar', $fila['auxiliar']);
                    $this->objParam->addParametro('orden', $fila['orden']);
                    $this->objParam->addParametro('suborden', $fila['suborden']);                  
                    $this->objParam->addParametro('debe', $fila['debe']);
                    $this->objParam->addParametro('haber', $fila['haber']);
					$this->objParam->addParametro('glosa', $fila['glosa']);
                    
                    $this->objFunc = $this->create('MODIntTransaccion');
                    $this->res = $this->objFunc->insertarIntTransaccionXLS($this->objParam);
                   
                    if ($this->res->getTipo() == 'ERROR') {
                    	
						$this->res->imprimirRespuesta($this->res->generarJson());
			            exit;
						
                        $error = 'error';
                        $mensaje_completo = "Error al guardar el fila en tabla :  " . $this->res->getMensajeTec();
                        break;
                    }
                }
            }
        } else {
            $mensaje_completo = "No se subio el archivo";
            $error = 'error_fatal';
        }
        
		

        if ($error == 'error_fatal') {
            $this->mensajeRes=new Mensaje();
            $this->mensajeRes->setMensaje('ERROR','ACTIntTransaccion.php',$mensaje_completo,
                $mensaje_completo,'control');
            //si no es error fatal proceso el archivo
        }

        if ($error == 'error') {
            $this->mensajeRes=new Mensaje();
            $this->mensajeRes->setMensaje('ERROR','ACTIntTransaccion.php','Ocurrieron los siguientes errores : ' . $mensaje_completo,
                $mensaje_completo,'control');

        } else if ($error == 'no') {
            $this->mensajeRes=new Mensaje();
            $this->mensajeRes->setMensaje('EXITO','ACTIntTransaccion.php','El archivo fue ejecutado con éxito',
                'El archivo fue ejecutado con éxito','control');
        }

        //devolver respuesta
        $this->mensajeRes->imprimirRespuesta($this->mensajeRes->generarJson());
    }
    
	function listarAuxiliarCuenta(){
		#5
		$this->objParam->defecto('ordenacion','orden');
		$this->objParam->defecto('dir_ordenacion','asc');			
		if($this->objParam->getParametro('tipo_filtro')=='con_detalle'){			
			if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
				$this->objReporte = new Reporte($this->objParam,$this);
				$this->res = $this->objReporte->generarReporteListado('MODIntTransaccion','listarAuxiliarCuenta');
			} else{
				$this->objFunc=$this->create('MODIntTransaccion');				
				$this->res=$this->objFunc->listarAuxiliarCuenta($this->objParam);
			}			
			if($this->objParam->getParametro('resumen')!='no'){
				//adicionar una fila al resultado con el summario
				$temp = Array();
				$temp['importe_debe_mb'] = $this->res->extraData['total_importe_debe_mb'];
				$temp['importe_haber_mb'] = $this->res->extraData['total_importe_haber_mb'];
				$temp['saldo'] = $this->res->extraData['total_saldo_mb'];			
				$temp['id_int_transaccion'] = 0;			
				$this->res->total++;			
				$this->res->addLastRecDatos($temp);
			}			
		}else{
			
			if($this->objParam->getParametro('tipo_filtro')=='sin_detalle'){
				
				if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
					$this->objReporte = new Reporte($this->objParam,$this);
					$this->res = $this->objReporte->generarReporteListado('MODIntTransaccion','listarTotal');
				} else{
					$this->objFunc=$this->create('MODIntTransaccion');				
					$this->res=$this->objFunc->listarTotal($this->objParam);
				}		
			}	
			$temp = Array();
			$temp['importe_debe_mb'] = $this->res->extraData['total_importe_debe_mb'];
			$temp['importe_haber_mb'] = $this->res->extraData['total_importe_haber_mb'];
			$temp['saldo'] = $this->res->extraData['total_saldo_mb'];			
			//$temp['saldo'] = $this->res->extraData['total_importe_debe_mb']-$this->res->extraData['total_importe_haber_mb'];
			$temp['id_int_transaccion'] = 0;			
			$this->res->total++;			
			$this->res->addLastRecDatos($temp);	
		}
		$this->res->imprimirRespuesta($this->res->generarJson());	
	}



	//mp
	function impReporteMayorSaldo() {
		if($this->objParam->getParametro('tipo_formato')=='pdf') {
			$nombreArchivo = uniqid(md5(session_id()).'LibroMayor').'.pdf';			
			$dataSource = $this->listarIntTransaccionMayorSaldo();
			$dataEntidad = "";
			$dataPeriodo = "";	
			$orientacion = 'P';		
			$tamano = 'LETTER';
			$titulo = 'Consolidado';
			$this->objParam->addParametro('orientacion',$orientacion);
			$this->objParam->addParametro('tamano',$tamano);		
			$this->objParam->addParametro('titulo_archivo',$titulo);	
			$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
			$reporte = new RTransaccionmayorSaldo($this->objParam);  
			$reporte->datosHeader($dataSource->getDatos(),$dataSource->extraData, '' , '');		
			$reporte->generarReporte();
			$reporte->output($reporte->url_archivo,'F');
			$this->mensajeExito=new Mensaje();
			$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genera con exito el reporte: '.$nombreArchivo,'control');
			$this->mensajeExito->setArchivoGenerado($nombreArchivo);
			$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());		
		}
		if($this->objParam->getParametro('tipo_formato')=='xls') {				
			/*$this->objFun=$this->create('MODIntTransaccion');	
			$this->res = $this->objFun->listarMayorSaldo();	
			if($this->res->getTipo()=='ERROR'){
				$this->res->imprimirRespuesta($this->res->generarJson());
				exit;
			}*/		
			$dataSource = $this->listarIntTransaccionMayorSaldo();
			$titulo ='Ret';
			$nombreArchivo=uniqid(md5(session_id()).$titulo);
			$nombreArchivo.='.xls';
			$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
			$this->objParam->addParametro('datos',$this->res->datos);
						
			$this->objReporteFormato=new RMayorXls($this->objParam);
			$this->objReporteFormato->generarDatos();
			$this->objReporteFormato->generarReporte();
			$this->mensajeExito=new Mensaje();
			$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con éxito el reporte: '.$nombreArchivo,'control');
			$this->mensajeExito->setArchivoGenerado($nombreArchivo);
			$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
		}					
	}

    function listaDetalleComprobanteTransacciones(){
	
		
		if($this->objParam->getParametro('id_gestion')!=''){
			$this->objParam->addFiltro("per.id_gestion = ".$this->objParam->getParametro('id_gestion'));	
		}
		if($this->objParam->getParametro('fecha_ini')!='' && $this->objParam->getParametro('fecha_fin')!=''){
			$this->objParam->addFiltro("( icbt.fecha::date  BETWEEN ''%".$this->objParam->getParametro('fecha_ini')."%''::date  and ''%".$this->objParam->getParametro('fecha_fin')."%''::date)");	
		}
		
		if($this->objParam->getParametro('fecha_ini')!='' && $this->objParam->getParametro('fecha_fin')==''){
			$this->objParam->addFiltro("( icbt.fecha::date  >= ''%".$this->objParam->getParametro('fecha_ini')."%''::date)");	
		}
		
		if($this->objParam->getParametro('fecha_ini')=='' && $this->objParam->getParametro('fecha_fin')!=''){
			$this->objParam->addFiltro("( icbt.fecha::date  <= ''%".$this->objParam->getParametro('fecha_fin')."%''::date)");	
		}
		
		if($this->objParam->getParametro('id_periodo')!=''){
			$this->objParam->addFiltro("per.id_periodo =".$this->objParam->getParametro('id_periodo'));    
		}
		
		if($this->objParam->getParametro('id_config_tipo_cuenta')!=''){
				$this->objParam->addFiltro("cue.tipo_cuenta = ''".$this->objParam->getParametro('id_config_tipo_cuenta')."''");	
		}
		if($this->objParam->getParametro('id_cuenta')!=''){
				$this->objParam->addFiltro("cue.id_cuenta = ".$this->objParam->getParametro('id_cuenta'));	
		}
		
		$this->exportarTxtLcvLCV();
		
	}
	function recuperarDatosEntidad(){    	
		$this->objFunc = $this->create('sis_parametros/MODEntidad');
		$cbteHeader = $this->objFunc->getEntidad($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
		
    }
	function recuperarDatosPeriodo(){    	
		$this->objFunc = $this->create('sis_parametros/MODPeriodo');
		$cbteHeader = $this->objFunc->getPeriodoById($this->objParam);
		if($cbteHeader->getTipo() == 'EXITO'){				
			return $cbteHeader;
		}
        else{
		    $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
			exit;
		}              
		
    }
    function exportarTxtLcvLCV(){
		
		//crea el objetoFunProcesoMacro que contiene todos los metodos del sistema de workflow
		$this->objFun=$this->create('MODIntTransaccion');		
		
		//$this->res = $this->objFun->listarRepLCVForm();
		$this->res = $this->objFun->listaDetalleComprobanteTransacciones();
		
			
		if($this->res->getTipo()=='ERROR'){
			$this->res->imprimirRespuesta($this->res->generarJson());
			exit;
		}
		
		$nombreArchivo = $this->crearArchivoExportacion($this->res, $this->objParam);
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Se genero con exito el archivo LCV'.$nombreArchivo,
										'Se genero con exito el archivo LCV'.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		
		$this->res->imprimirRespuesta($this->mensajeExito->generarJson());

	 }
	function crearArchivoExportacion($res, $Obj) {
		
		$separador = '|';
		if($this->objParam->getParametro('formato_reporte') =='txt')
		{
			$separador = "|";
			$ext = '.txt';
		}
		else{
			//$separador = ",";
			$separador = "|";
			$ext = '.csv';
		}
		
		 
		$dataEntidad = $this->recuperarDatosEntidad();
		$dataEntidadArray = $dataEntidad->getDatos();
		$NIT = 	$dataEntidadArray['nit'];
		 
		if($this->objParam->getParametro('filtro_sql')=='periodo'){
			$dataPeriodo = $this->recuperarDatosPeriodo();
			$dataPeriodoArray = $dataPeriodo->getDatos();
		    $sufijo = $dataPeriodoArray['periodo'].$dataPeriodoArray['gestion'];
		}
		else{
			$sufijo=$this->objParam->getParametro('fecha_ini').'_'.$this->objParam->getParametro('fecha_fin');
		}
		
		$nombre ='DetalleComprobante-Transaccion';
		
		
		$nombre=str_replace("/", "", $nombre);
		
		
		$data = $res -> getDatos();
		$fileName = $nombre.$ext;
		//create file
		$file = fopen("../../../reportes_generados/$fileName","w+");
		$ctd = 1;
		
		if($this->objParam->getParametro('formato_reporte') !='txt'){

		    fwrite($file, pack("CCC",0xef,0xbb,0xbf));
		}
		if($this->objParam->getParametro('tipo_reporte') !='auditoria'){
		      fwrite($file,
				'N#' . $separador .
				'id_int_comprobante' . $separador .
				"id_int_transaccion" . $separador . 
				
				//'fecha_reg' . $separador .
				'fecha' . $separador .
				'nro_cbte' . $separador .
				'nro_tramite' . $separador .
				//'glosa1' . $separador .
				"debe_mb" . $separador .
				"haber_mb" . $separador .
				"saldo_debehaber_mb" . $separador .
				//"gasto_mb" . $separador .
				//"recurso_mb" . $separador .
				
				//"saldo_gastorecurso_mb" . $separador .
				"debe_mt" . $separador . 
				"haber_mt" . $separador . 
				"saldo_debehaber_mt" . $separador . 
				//"gasto_mt" . $separador .
				//"recurso_mt" . $separador .

				//"saldo_gastorecurso_mt" . $separador .
				"debe_ma" . $separador . 
				"haber_ma" . $separador . 
				"saldo_debehaber_ma" . $separador . 
				//"gasto_ma" . $separador .
				//"recurso_ma" . $separador .
			    //"saldo_gastorecurso_ma" . $separador .
				
				"tc_ufv" . $separador . 
				"tipo_cuenta" . $separador . 
				"cuenta_nro" . $separador . 
				"cuenta" . $separador . 
				"partida_tipo" . $separador . 
				"partida_codigo" . $separador . 
				
				"partida" . $separador . 
				"centro_costo_techo_codigo" . $separador . 
				"centro_costo_techo" . $separador . 
				"centro_costo_codigo" . $separador . 
				"centro_costo" . $separador . 
				"aux_codigo" . $separador . 
				"aux_nombre" . $separador . 
                "nombre" . $separador .
                //************************
                //******NUEVOS************
                "beneficiario" . $separador .
                "tipo_cbte" . $separador .
                "glosa" . $separador .
                "persona_create" . $separador .
                "persona_mod" . $separador .
                "nro_tramite_aux" . $separador .
				"\r\n"
				
				);
		}
		else{
		      fwrite($file,
				'N#' . $separador .
				'id_int_comprobante' . $separador .
				"id_int_transaccion" . $separador . 
				
				//'fecha_reg' . $separador .
				'fecha' . $separador .
				'nro_cbte' . $separador .
				'nro_tramite' . $separador .
				//'glosa1' . $separador .
				"debe_mb" . $separador .
				"haber_mb" . $separador .
				"saldo_debehaber_mb" . $separador .
				//"gasto_mb" . $separador .
				//"recurso_mb" . $separador .
				
				//"saldo_gastorecurso_mb" . $separador .
				"debe_mt" . $separador . 
				"haber_mt" . $separador . 
				"saldo_debehaber_mt" . $separador . 
				//"gasto_mt" . $separador .
				//"recurso_mt" . $separador .
				
				//"saldo_gastorecurso_mt" . $separador .
				"debe_ma" . $separador . 
				"haber_ma" . $separador . 
				"saldo_debehaber_ma" . $separador . 
				//"gasto_ma" . $separador .
				//"recurso_ma" . $separador .
				//"saldo_gastorecurso_ma" . $separador .
				
				"tc_ufv" . $separador . 
				"tipo_cuenta" . $separador . 
				"cuenta_nro" . $separador . 
				"cuenta" . $separador . 
				"partida_tipo" . $separador . 
				"partida_codigo" . $separador . 
				
				"partida" . $separador . 
				"centro_costo_techo_codigo" . $separador . 
				"centro_costo_techo" . $separador . 
				"centro_costo_codigo" . $separador . 
				"centro_costo" . $separador . 
				"aux_codigo" . $separador . 
				"aux_nombre" . $separador . 

				"tipo_transaccion" . $separador . 
				"periodo" . $separador . 
				"hora" . $separador . 
				"fecha_reg_transaccion" . $separador . 
				"usuario_reg_transaccion" . $separador . 
				"nro_documento" . $separador . 
				"glosa_transaccion" . $separador .
                //************************
                //******NUEVOS************
                "beneficiario" . $separador .
                "tipo_cbte" . $separador .
                "glosa" . $separador .
                "persona_create" . $separador .
                "persona_mod" . $separador .
                "nro_tramite_aux" . $separador .
								    
				"\r\n"
				
				);
		} 
		

					
		
		foreach ($data as $val) {
			
			 $newDate = date("d/m/Y", strtotime( $val['fecha']));	
			 		 
             if($this->objParam->getParametro('tipo_reporte') !='auditoria'){
					fwrite ($file, 
				 	                $ctd.$separador.
			                        $val['id_int_comprobante'].$separador.
									$val['id_int_transaccion'].$separador.
								   
			                       // $val['fecha_reg'].$separador. 
			                        $val['fecha'].$separador.
									$val['nro_cbte'].$separador.

			                        $val['nro_tramite'].$separador.
			                        //$val['glosa1'].$separador.
			                        $val['debe_mb'].$separador.
			                        $val['haber_mb'].$separador.
									$val['saldo_debehaber_mb'].$separador.
									//$val['gasto_mb'].$separador.
									//$val['recurso_mb'].$separador.
									
									//$val['saldo_gastorecurso_mb'].$separador.
			                        $val['debe_mt'].$separador.
			                        $val['haber_mt'].$separador.
									$val['saldo_debehaber_mt'].$separador.
									//$val['gasto_mt'].$separador.
									//$val['recurso_mt'].$separador.
									
									//$val['saldo_gastorecurso_mt'].$separador.
			                        $val['debe_ma'].$separador.
			                        $val['haber_ma'].$separador.
									$val['saldo_debehaber_ma'].$separador.
									//$val['gasto_ma'].$separador.
									//$val['recurso_ma'].$separador.
									//$val['saldo_gastorecurso_ma'].$separador.
									
									$val['tc_ufv'].$separador.
									$val['tipo_cuenta'].$separador.
									$val['cuenta_nro'].$separador.
									$val['cuenta'].$separador.
									$val['partida_tipo'].$separador.
									$val['partida_codigo'].$separador.
									
									$val['partida'].$separador.
									$val['centro_costo_techo_codigo'].$separador.
									$val['centro_costo_techo'].$separador.
									$val['centro_costo_codigo'].$separador.
									$val['centro_costo'].$separador.
									$val['aux_codigo'].$separador.
									$val['aux_nombre'].$separador.
                                    $val['nombre'].$separador.
                                    //************************
                                    //******NUEVOS************
                                    $val['beneficiario'].$separador.
                                    $val['tipo_cbte'].$separador.
                                    $val['glosa'].$separador.
                                    $val['persona_create'].$separador.
                                    $val['persona_mod'].$separador.
                                    $val['nro_tramite_aux'].$separador.
			                        "\r\n"
									);
			 }
			 else{
					fwrite ($file, 
				 	                $ctd.$separador.
			                        $val['id_int_comprobante'].$separador.
									$val['id_int_transaccion'].$separador.
								   
			                       // $val['fecha_reg'].$separador. 
			                        $val['fecha'].$separador.
									$val['nro_cbte'].$separador.

			                        $val['nro_tramite'].$separador.
			                        //$val['glosa1'].$separador.
			                        $val['debe_mb'].$separador.
			                        $val['haber_mb'].$separador.
									$val['saldo_debehaber_mb'].$separador.
									$val['gasto_mb'].$separador.
									$val['recurso_mb'].$separador.
									
									$val['saldo_gastorecurso_mb'].$separador.
			                        $val['debe_mt'].$separador.
			                        $val['haber_mt'].$separador.
									$val['saldo_debehaber_mt'].$separador.
									$val['gasto_mt'].$separador.
									$val['recurso_mt'].$separador.
									
									$val['saldo_gastorecurso_mt'].$separador.
			                        $val['debe_ma'].$separador.
			                        $val['haber_ma'].$separador.
									$val['saldo_debehaber_ma'].$separador.
									$val['gasto_ma'].$separador.
									$val['recurso_ma'].$separador.
									$val['saldo_gastorecurso_ma'].$separador.
									
									$val['tc_ufv'].$separador.
									$val['tipo_cuenta'].$separador.
									$val['cuenta_nro'].$separador.
									$val['cuenta'].$separador.
									$val['partida_tipo'].$separador.
									$val['partida_codigo'].$separador.
									
									$val['partida'].$separador.
									$val['centro_costo_techo_codigo'].$separador.
									$val['centro_costo_techo'].$separador.
									$val['centro_costo_codigo'].$separador.
									$val['centro_costo'].$separador.
									$val['aux_codigo'].$separador.
									$val['aux_nombre'].$separador.
                                    //************************
                                    //******NUEVOS************
                                    $val['beneficiario'].$separador.
                                    $val['tipo_cbte'].$separador.
                                    $val['glosa'].$separador.
                                    $val['persona_create'].$separador.
                                    $val['persona_mod'].$separador.
                                    $val['nro_tramite_aux'].$separador.
                                    //******************************
                                    $val['tipo_transaccion'].$separador.
								    $val['periodo'].$separador.
								    $val['hora'].$separador.
								    $val['fecha_reg_transaccion'].$separador.
								    $val['usuario_reg_transaccion'].$separador.
								    $val['nro_documento'].$separador.
								    $val['glosa_transaccion'].$separador.
			                        "\r\n"
									);
			 }
			 $ctd = $ctd + 1;
         } //end for
         
     
				
		fclose($file);
		return $fileName;
	}

    /***************#92-INI-MMV**************/
    function mayorNroTramite(){
        $this->objParam->defecto('ordenacion','orden');
        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODIntTransaccion','mayorNroTramite');
        } else{
            $this->objFunc=$this->create('MODIntTransaccion');
            $this->res=$this->objFunc->mayorNroTramite($this->objParam);
        }
        //adicionar una fila al resultado con el summario
        $temp = Array();
        $temp['codigo_auxiliar'] = 'Total';
        $temp['importe_debe_mb'] = $this->res->extraData['importe_debe_mb_total'];
        $temp['importe_haber_mb'] = $this->res->extraData['importe_haber_mb_total'];
        $temp['saldo_mb'] = $this->res->extraData['saldo_mb_total'];
        $temp['importe_debe_mt'] = $this->res->extraData['importe_debe_mt_total'];
        $temp['importe_haber_mt'] = $this->res->extraData['importe_haber_mt_total'];
        $temp['saldo_mt'] = $this->res->extraData['saldo_mt_total'];
        $temp['importe_debe_ma'] = $this->res->extraData['importe_debe_ma_total'];
        $temp['importe_haber_ma'] = $this->res->extraData['importe_haber_ma_total'];
        $temp['saldo_ma'] = $this->res->extraData['saldo_ma_total'];
        $temp['id_int_comprobante'] = 0;
        $this->res->total++;
        $this->res->addLastRecDatos($temp);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function reporteAuxliarTramite() {
        $this->objFunc=$this->create('MODIntTransaccion');
        $this->res=$this->objFunc->mayorNroTramiteReporte($this->objParam);
        $titulo = 'Auxiliar';
        $nombreArchivo = uniqid(md5(session_id()) . $titulo);
        $nombreArchivo .= '.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('datos', $this->res->datos);
        $this->objReporteFormato=new RAuxliarTramitesXls($this->objParam);
        $this->objReporteFormato->generarDatos();
        $this->objReporteFormato->generarReporte();
        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }
    /***************#92-FIN-MMV**************/
    /***************#2-INI-MMV**************/
    function reporteProyecto()
    {
        $this->objFunc = $this->create('MODIntTransaccion');
        $this->res = $this->objFunc->reporteProyecto($this->objParam);
        //var_dump($this->res);exit;
        $titulo = 'Proyectos';
        $nombreArchivo = uniqid(md5(session_id()) . $titulo);
        $nombreArchivo .= '.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('datos', $this->res->datos);

        $this->objReporteFormato = new RProyectosArbol($this->objParam);
        $this->objReporteFormato->imprimirDatos();
        $this->objReporteFormato->generarReporte();
        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado', 'Se genero con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }
    /***************#2-FIN-MMV**************/

    function listarExcelTransaccion (){

        if($this->objParam->getParametro('id_int_comprobante')!=''){
            $this->objParam->addFiltro("transa.id_int_comprobante = ".$this->objParam->getParametro('id_int_comprobante'));
        }


        if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("per.id_gestion = ".$this->objParam->getParametro('id_gestion'));
        }

        if($this->objParam->getParametro('id_config_tipo_cuenta')!=''){
            $this->objParam->addFiltro("ctc.id_config_tipo_cuenta = ".$this->objParam->getParametro('id_config_tipo_cuenta'));
        }

        if($this->objParam->getParametro('id_config_subtipo_cuenta')!=''){
            $this->objParam->addFiltro("csc.id_config_subtipo_cuenta = ".$this->objParam->getParametro('id_config_subtipo_cuenta'));
        }


        if($this->objParam->getParametro('id_depto')!=''){
            $this->objParam->addFiltro("icbte.id_depto = ".$this->objParam->getParametro('id_depto'));
        }
        #6
        if($this->objParam->getParametro('cbte_cierre')=='todos'){
            $this->objParam->addFiltro("icbte.cbte_cierre in (''no'',''balance'',''resultado'')");
        }else{
            if($this->objParam->getParametro('cbte_cierre')=='balance'){
                $this->objParam->addFiltro("icbte.cbte_cierre in (''balance'')");
            }else{
                if($this->objParam->getParametro('cbte_cierre')=='resultado'){
                    $this->objParam->addFiltro("icbte.cbte_cierre in (''resultado'')");
                }else{
                    if($this->objParam->getParametro('cbte_cierre')=='no'){
                        $this->objParam->addFiltro("icbte.cbte_cierre in (''no'')");
                    }
                }
            }
        }

        if($this->objParam->getParametro('id_partida')!=''){
            $this->objParam->addFiltro("transa.id_partida = ".$this->objParam->getParametro('id_partida'));
        }

        if($this->objParam->getParametro('id_suborden')!=''){
            $this->objParam->addFiltro("transa.id_subordeno = ".$this->objParam->getParametro('id_suborden'));
        }


        if($this->objParam->getParametro('id_auxiliar')!=''){
            $this->objParam->addFiltro("transa.id_auxiliar = ".$this->objParam->getParametro('id_auxiliar'));
        }

        if($this->objParam->getParametro('id_centro_costo')!=''){
            $this->objParam->addFiltro("transa.id_centro_costo = ".$this->objParam->getParametro('id_centro_costo'));
        }

        if($this->objParam->getParametro('nro_tramite')!=''){
            $this->objParam->addFiltro("icbte.nro_tramite ilike ''%".$this->objParam->getParametro('nro_tramite')."%''");
        }
        #17
        if($this->objParam->getParametro('nro_tramite_aux')!=''){
            $this->objParam->addFiltro("icbte.nro_tramite_aux ilike ''%".$this->objParam->getParametro('nro_tramite_aux')."%''");
        }

        if($this->objParam->getParametro('cerrado')=='si'){
            $this->objParam->addFiltro("transa.cerrado in (''no'')");
        }else{
            $this->objParam->addFiltro("transa.cerrado in (''si'',''no'')");
        }
        if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')!=''){
            $this->objParam->addFiltro("(icbte.fecha::date  BETWEEN ''%".$this->objParam->getParametro('desde')."%''::date  and ''%".$this->objParam->getParametro('hasta')."%''::date)");
        }

        if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')==''){
            $this->objParam->addFiltro("(icbte.fecha::date  >= ''%".$this->objParam->getParametro('desde')."%''::date)");
        }

        if($this->objParam->getParametro('desde')=='' && $this->objParam->getParametro('hasta')!=''){
            $this->objParam->addFiltro("(icbte.fecha::date  <= ''%".$this->objParam->getParametro('hasta')."%''::date)");
        }
        $this->objFunc=$this->create('MODIntTransaccion');
        $cbteHeader = $this->objFunc->listarExcelIntTransaccionMayor($this->objParam);

        if($cbteHeader->getTipo() == 'EXITO'){
            return $cbteHeader;
        }
        else{
            $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
            exit;
        }
    }
    function reporteExcelTransaccion(){
        $dataSource = $this->listarExcelTransaccion();
        $nombreArchivo = uniqid(md5(session_id()).'ExcelTest').'.xls';
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
        $reporte = new RIntTransaccionMayorExcel($this->objParam);
        $reporte->datosHeader($dataSource->getDatos());
        $reporte->generarReporte();
        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }
		
}

?>