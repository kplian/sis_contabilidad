<?php
/**
*@package pXP
*@file gen-ACTPlantillaComprobante.php
*@author  (admin)
*@date 10-06-2013 14:40:00
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPlantillaComprobante extends ACTbase{    
			
	function listarPlantillaComprobante(){
		$this->objParam->defecto('ordenacion','id_plantilla_comprobante');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPlantillaComprobante','listarPlantillaComprobante');
		} else{
			$this->objFunc=$this->create('MODPlantillaComprobante');
			
			$this->res=$this->objFunc->listarPlantillaComprobante($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPlantillaComprobante(){
		$this->objFunc=$this->create('MODPlantillaComprobante');	
		if($this->objParam->insertar('id_plantilla_comprobante')){
			$this->res=$this->objFunc->insertarPlantillaComprobante($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPlantillaComprobante($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPlantillaComprobante(){
			$this->objFunc=$this->create('MODPlantillaComprobante');	
		$this->res=$this->objFunc->eliminarPlantillaComprobante($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function exportarDatos(){
		
		//crea el objetoFunProcesoMacro que contiene todos los metodos del sistema de workflow
		$this->objFunProcesoMacro=$this->create('MODPlantillaComprobante');		
		
		$this->res = $this->objFunProcesoMacro->exportarDatos();
		
		if($this->res->getTipo()=='ERROR'){
			$this->res->imprimirRespuesta($this->res->generarJson());
			exit;
		}
		
		$nombreArchivo = $this->crearArchivoExportacion($this->res);
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Se genero con exito el sql'.$nombreArchivo,
										'Se genero con exito el sql'.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		
		$this->res->imprimirRespuesta($this->mensajeExito->generarJson());

	}
	
	function crearArchivoExportacion($res) {
		$data = $res -> getDatos();
		$fileName = uniqid(md5(session_id()).'PlantillaCalculo').'.sql';
		//create file
		$file = fopen("../../../reportes_generados/$fileName", 'w');
		
		$sw_gui = 0;
		$sw_funciones=0;
		$sw_procedimiento=0;
		$sw_rol=0; 
		$sw_rol_pro=0;
		fwrite ($file,"----------------------------------\r\n".
						  "--COPY LINES TO SUBSYSTEM data.sql FILE  \r\n".
						  "---------------------------------\r\n".
						  "\r\n" );
		foreach ($data as $row) {			
			 if ($row['tipo_reg'] == 'maestro' ) {
			 	
				if ($row['estado_reg'] == 'inactivo') {
					fwrite ($file, 
					"select conta.f_import_tplantilla_comprobante ('delete','".							 
							$row['codigo']."',
							NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL);\r\n");
							
				} else {
					fwrite ($file, 
					 "select conta.f_import_tplantilla_comprobante ('insert','".
								$row['codigo']."'," .
						     (is_null($row['funcion_comprobante_eliminado'])?'NULL':"'".$row['funcion_comprobante_eliminado']."'") ."," .
							 (is_null($row['id_tabla'])?'NULL':"'".$row['id_tabla']."'") ."," .
							 (is_null($row['campo_subsistema'])?'NULL':"'".$row['campo_subsistema']."'") ."," .
							 (is_null($row['campo_descripcion'])?'NULL':"'".$row['campo_descripcion']."'") ."," .							 
							 (is_null($row['funcion_comprobante_validado'])?'NULL':"'".$row['funcion_comprobante_validado']."'") ."," .							 
							 (is_null($row['campo_fecha'])?'NULL':"'".$row['campo_fecha']."'") ."," .							 
							 (is_null($row['estado_reg'])?'NULL':"'".$row['estado_reg']."'") ."," .							 
							 (is_null($row['campo_acreedor'])?'NULL':"'".$row['campo_acreedor']."'") ."," .							 
							 (is_null($row['campo_depto'])?'NULL':"'".$row['campo_depto']."'") ."," .							 
							 (is_null($row['momento_presupuestario'])?'NULL':"'".$row['momento_presupuestario']."'") ."," .							 
							 (is_null($row['campo_fk_comprobante'])?'NULL':"'".$row['campo_fk_comprobante']."'")."," .							 
							 (is_null($row['tabla_origen'])?'NULL':"'".$row['tabla_origen']."'") ."," .							  
							 (is_null($row['clase_comprobante'])?'NULL':"'".$row['clase_comprobante']."'") ."," .							 
							 (is_null($row['campo_moneda'])?'NULL':"'".$row['campo_moneda']."'")."," .							 
							 (is_null($row['campo_gestion_relacion'])?'NULL':"'".$row['campo_gestion_relacion']."'") ."," .							  
							 (is_null($row['otros_campos'])?'NULL':"'".$row['otros_campos']."'") ."," .							 
							 (is_null($row['momento_comprometido'])?'NULL':"'".$row['momento_comprometido']."'")."," .							 
							 (is_null($row['momento_ejecutado'])?'NULL':"'".$row['momento_ejecutado']."'") ."," .							  
							 (is_null($row['momento_pagado'])?'NULL':"'".$row['momento_pagado']."'") ."," .							 
							 (is_null($row['campo_id_cuenta_bancaria'])?'NULL':"'".$row['campo_id_cuenta_bancaria']."'")."," .							 	
							 (is_null($row['campo_id_cuenta_bancaria_mov'])?'NULL':"'".$row['campo_id_cuenta_bancaria_mov']."'") ."," .							 
							 (is_null($row['campo_nro_cheque'])?'NULL':"'".$row['campo_nro_cheque']."'") ."," .							 
							 (is_null($row['campo_nro_cuenta_bancaria_trans'])?'NULL':"'".$row['campo_nro_cuenta_bancaria_trans']."'")."," .							 	
							 (is_null($row['campo_nro_tramite'])?'NULL':"'".$row['campo_nro_tramite']."'") ."," .							 
							 (is_null($row['campo_tipo_cambio'])?'NULL':"'".$row['campo_tipo_cambio']."'") ."," .							 
							 (is_null($row['campo_depto_libro'])?'NULL':"'".$row['campo_depto_libro']."'")."," .							 
							 (is_null($row['campo_fecha_costo_ini'])?'NULL':"'".$row['campo_fecha_costo_ini']."'") ."," .							 
							 (is_null($row['campo_fecha_costo_fin'])?'NULL':"'".$row['campo_fecha_costo_fin']."'")."," .
							 (is_null($row['funcion_comprobante_editado'])?'NULL':"'".$row['funcion_comprobante_editado']."'")."," .
							 (is_null($row['desc_plantilla'])?'NULL':"'".$row['desc_plantilla']."'").");\r\n");				
							 
							 	
				}
			 } else if ($row['tipo_reg'] == 'detalle') {
				if ($row['estado_reg'] == 'inactivo') {
						
					fwrite ($file, 
					"select conta.f_import_tdetalle_plantilla_comprobante ('delete','".							 
							$row['codigo_plantilla']."','".
							$row['codigo']."',
							NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);\r\n");	
	
			} else {
					
					fwrite ($file, 
					 "select conta.f_import_tdetalle_plantilla_comprobante ('insert',".
							 
							 (is_null($row['codigo_plantilla'])?'NULL':"'".$row['codigo_plantilla']."'") ."," .
							 (is_null($row['codigo'])?'NULL':"'".$row['codigo']."'") ."," .
							 (is_null($row['debe_haber'])?'NULL':"'".$row['debe_haber']."'") ."," .
							 (is_null($row['agrupar'])?'NULL':"'".$row['agrupar']."'") ."," .
							 (is_null($row['es_relacion_contable'])?'NULL':"'".$row['es_relacion_contable']."'") ."," .
							 (is_null($row['campo_partida'])?'NULL':"'".$row['campo_partida']."'") ."," .
							 (is_null($row['campo_concepto_transaccion'])?'NULL':"'".$row['campo_concepto_transaccion']."'") ."," .
							 (is_null($row['tipo_relacion_contable'])?'NULL':"'".$row['tipo_relacion_contable']."'") ."," .
							 (is_null($row['campo_cuenta'])?'NULL':"'".$row['campo_cuenta']."'") ."," .
							 (is_null($row['campo_monto'])?'NULL':"'".$row['campo_monto']."'") ."," .
							 (is_null($row['campo_relacion_contable'])?'NULL':"'".$row['campo_relacion_contable']."'") ."," .
							 (is_null($row['campo_documento'])?'NULL':"'".$row['campo_documento']."'") ."," .
							 (is_null($row['aplicar_documento'])?'NULL':"'".$row['aplicar_documento']."'") ."," .
							 (is_null($row['campo_centro_costo'])?'NULL':"'".$row['campo_centro_costo']."'") ."," .
							 (is_null($row['campo_auxiliar'])?'NULL':"'".$row['campo_auxiliar']."'") ."," .
							 (is_null($row['campo_fecha'])?'NULL':"'".$row['campo_fecha']."'") ."," .
							 (is_null($row['primaria'])?'NULL':"'".$row['primaria']."'") ."," .
							 (is_null($row['otros_campos'])?'NULL':"'".$row['otros_campos']."'") ."," .
							 (is_null($row['nom_fk_tabla_maestro'])?'NULL':"'".$row['nom_fk_tabla_maestro']."'") ."," .
							 (is_null($row['campo_partida_ejecucion'])?'NULL':"'".$row['campo_partida_ejecucion']."'") ."," .
							 (is_null($row['descripcion'])?'NULL':"'".$row['descripcion']."'") ."," .
							 (is_null($row['campo_monto_pres'])?'NULL':"'".$row['campo_monto_pres']."'") ."," .
							 (is_null($row['id_detalle_plantilla_fk'])?'NULL':"'".$row['id_detalle_plantilla_fk']."'") ."," .
							 (is_null($row['forma_calculo_monto'])?'NULL':"'".$row['forma_calculo_monto']."'") ."," .
							 (is_null($row['func_act_transaccion'])?'NULL':"'".$row['func_act_transaccion']."'") ."," .
							 (is_null($row['campo_id_tabla_detalle'])?'NULL':"'".$row['campo_id_tabla_detalle']."'") ."," .
							 (is_null($row['rel_dev_pago'])?'NULL':"'".$row['rel_dev_pago']."'") ."," .
							 (is_null($row['campo_trasaccion_dev'])?'NULL':"'".$row['campo_trasaccion_dev']."'") ."," .
							 (is_null($row['campo_id_cuenta_bancaria'])?'NULL':"'".$row['campo_id_cuenta_bancaria']."'") ."," .
							 (is_null($row['campo_id_cuenta_bancaria_mov'])?'NULL':"'".$row['campo_id_cuenta_bancaria_mov']."'") ."," .
							 (is_null($row['campo_nro_cheque'])?'NULL':"'".$row['campo_nro_cheque']."'") ."," .
							 (is_null($row['campo_nro_cuenta_bancaria_trans'])?'NULL':"'".$row['campo_nro_cuenta_bancaria_trans']."'") ."," .
							 (is_null($row['campo_porc_monto_excento_var'])?'NULL':"'".$row['campo_porc_monto_excento_var']."'") ."," .
							 (is_null($row['campo_nombre_cheque_trans'])?'NULL':"'".$row['campo_nombre_cheque_trans']."'") ."," .
							 (is_null($row['prioridad_documento'])?'NULL':"'".$row['prioridad_documento']."'") ."," .
							 (is_null($row['campo_orden_trabajo'])?'NULL':"'".$row['campo_orden_trabajo']."'") ."," .
							 (is_null($row['tabla_detalle'])?'NULL':"'".$row['tabla_detalle']."'") ."," .
							 (is_null($row['codigo_fk'])?'NULL':"'".$row['codigo_fk']."'")."," .
							 (is_null($row['campo_forma_pago'])?'NULL':"'".$row['campo_forma_pago']."'")."," .	
							 
							 (is_null($row['tipo_relacion_contable_cc'])?'NULL':"'".$row['tipo_relacion_contable_cc']."'")."," .
							 (is_null($row['campo_relacion_contable_cc'])?'NULL':"'".$row['campo_relacion_contable_cc']."'")."," .	
							 (is_null($row['campo_suborden'])?'NULL':"'".$row['campo_suborden']."'") .");\r\n");
							 
							 						
				}
			} 
         } //end for
		
		
		return $fileName;
	}
			
}

?>