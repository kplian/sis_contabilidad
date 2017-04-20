<?php
/**
*@package pXP
*@file gen-MODBancaCompraVenta.php
*@author  (admin)
*@date 11-09-2015 14:36:46
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODBancaCompraVenta extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
		
		$this->cone = new conexion();
		$this->link = $this->cone->conectarpdo(); //conexion a pxp(postgres)
	}
			
	function listarBancaCompraVenta(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_banca_compra_venta_sel';
		$this->transaccion='CONTA_BANCA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		
		if($_SESSION["BANCA_DOCUMENTOS"] == NULL){
			$_SESSION["BANCA_DOCUMENTOS"] = "pxp"; // si no tiene esa variable entrara por defecto en las tablas del pxp
		}
		
		$this->aParam->addParametro('banca_documentos', $_SESSION["BANCA_DOCUMENTOS"]);
		$this->arreglo['banca_documentos'] = $_SESSION["BANCA_DOCUMENTOS"];
		$this->setParametro('banca_documentos','banca_documentos','varchar');	
		
		
		$this->setParametro('acumulado','acumulado','varchar');
		$this->setParametro('id_banca_compra_venta','id_banca_compra_venta','int4');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_banca_compra_venta','int4');
		$this->captura('num_cuenta_pago','varchar');
		$this->captura('tipo_documento_pago','numeric');
		$this->captura('num_documento','varchar');
		$this->captura('monto_acumulado','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('nit_ci','varchar');
		$this->captura('importe_documento','numeric');
		$this->captura('fecha_documento','date');
		$this->captura('modalidad_transaccion','int4');
		$this->captura('tipo_transaccion','int4');
		$this->captura('autorizacion','numeric');
		$this->captura('monto_pagado','numeric');
		$this->captura('fecha_de_pago','date');
		$this->captura('razon','varchar');
		$this->captura('tipo','varchar');
		$this->captura('num_documento_pago','varchar');
		$this->captura('num_contrato','varchar');
		$this->captura('nit_entidad','numeric');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_periodo','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_modalidad_transaccion','varchar');
		$this->captura('desc_tipo_transaccion','varchar');
		$this->captura('desc_tipo_documento_pago','varchar');
		$this->captura('revisado','varchar');
		$this->captura('id_contrato','int4');
		$this->captura('id_proveedor','int4');
		$this->captura('desc_proveedor2','varchar');
         $this->captura('desc_contrato','text');     
		 $this->captura('id_cuenta_bancaria','int4'); 
		 $this->captura('desc_cuenta_bancaria','varchar'); 
		 $this->captura('id_documento','int4'); 
		 $this->captura('desc_documento','varchar'); 
		$this->captura('periodo','varchar'); 
		$this->captura('saldo','numeric');
		$this->captura('monto_contrato','numeric');
		$this->captura('gestion','int4');
		
		$this->captura('banca_seleccionada','int4');
		
		$this->captura('numero_cuota','int4');
		$this->captura('tramite_cuota','varchar'); 

	$this->captura('id_proceso_wf','int4');
	
	
	$this->captura('resolucion','varchar'); 
	$this->captura('tipo_monto','varchar'); 
	
	
	$this->captura('retencion_cuota','numeric');
	$this->captura('multa_cuota','numeric');
	$this->captura('rotulo_comercial','varchar'); 
	$this->captura('estado_libro','varchar'); 
	
	$this->captura('periodo_servicio','varchar');
	
	$this->captura('lista_negra','varchar');
	
	$this->captura('tipo_bancarizacion','varchar');
	
	
	
	
	
	
	
	
	
	

	
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarBancaCompraVenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_banca_compra_venta_ime';
		$this->transaccion='CONTA_BANCA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('num_cuenta_pago','num_cuenta_pago','varchar');
		$this->setParametro('tipo_documento_pago','tipo_documento_pago','numeric');
		$this->setParametro('num_documento','num_documento','varchar');
		$this->setParametro('monto_acumulado','monto_acumulado','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nit_ci','nit_ci','varchar');
		$this->setParametro('importe_documento','importe_documento','numeric');
		$this->setParametro('fecha_documento','fecha_documento','date');
		$this->setParametro('modalidad_transaccion','modalidad_transaccion','int4');
		$this->setParametro('tipo_transaccion','tipo_transaccion','int4');
		$this->setParametro('autorizacion','autorizacion','numeric');
		$this->setParametro('monto_pagado','monto_pagado','numeric');
		$this->setParametro('fecha_de_pago','fecha_de_pago','date');
		$this->setParametro('razon','razon','varchar');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('num_documento_pago','num_documento_pago','varchar');
		$this->setParametro('num_contrato','num_contrato','varchar');
		$this->setParametro('nit_entidad','nit_entidad','numeric');
		
		$this->setParametro('id_periodo','id_periodo','int4');
		
		$this->setParametro('id_depto_conta','id_depto_conta','int4');
		
		$this->setParametro('id_proveedor','id_proveedor','int4');
		$this->setParametro('id_contrato','id_contrato','int4');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('id_documento','id_documento','int4');
		
		$this->setParametro('periodo_servicio','periodo_servicio','varchar');

		$this->setParametro('numero_cuota','numero_cuota','int4');
		$this->setParametro('tramite_cuota','tramite_cuota','varchar');
		
		
		
		
		
				
	

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarBancaCompraVenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_banca_compra_venta_ime';
		$this->transaccion='CONTA_BANCA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_banca_compra_venta','id_banca_compra_venta','int4');
		$this->setParametro('num_cuenta_pago','num_cuenta_pago','varchar');
		$this->setParametro('tipo_documento_pago','tipo_documento_pago','numeric');
		$this->setParametro('num_documento','num_documento','varchar');
		$this->setParametro('monto_acumulado','monto_acumulado','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nit_ci','nit_ci','varchar');
		$this->setParametro('importe_documento','importe_documento','numeric');
		$this->setParametro('fecha_documento','fecha_documento','date');
		$this->setParametro('modalidad_transaccion','modalidad_transaccion','int4');
		$this->setParametro('tipo_transaccion','tipo_transaccion','int4');
		$this->setParametro('autorizacion','autorizacion','numeric');
		$this->setParametro('monto_pagado','monto_pagado','numeric');
		$this->setParametro('fecha_de_pago','fecha_de_pago','date');
		$this->setParametro('razon','razon','varchar');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('num_documento_pago','num_documento_pago','varchar');
		$this->setParametro('num_contrato','num_contrato','varchar');
		$this->setParametro('nit_entidad','nit_entidad','numeric');
		
		$this->setParametro('id_periodo','id_periodo','int4');
		
		$this->setParametro('id_depto_conta','id_depto_conta','int4');
		
		$this->setParametro('id_proveedor','id_proveedor','int4');
		$this->setParametro('id_contrato','id_contrato','int4');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');
		$this->setParametro('id_documento','id_documento','int4');
		
		$this->setParametro('revisado','revisado','varchar');
		
		$this->setParametro('monto_contrato','monto_contrato','numeric');
		$this->setParametro('tramite_cuota','tramite_cuota','varchar');
		
				$this->setParametro('periodo_servicio','periodo_servicio','varchar');
		
		$this->setParametro('saldo','saldo','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarBancaCompraVenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_banca_compra_venta_ime';
		$this->transaccion='CONTA_BANCA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_banca_compra_venta','id_banca_compra_venta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function listarPeriodoGestion(){
		
		
		$id_periodo = $this->objParam->getParametro('id_periodo');
		$res = $this->link->prepare("select per.periodo,ges.gestion from param.tperiodo per
										inner join param.tgestion ges on ges.id_gestion = per.id_gestion
										where per.id_periodo = '$id_periodo' ");
		$res->execute();
		$result = $res->fetchAll(PDO::FETCH_ASSOC);
		return $result;
		
	}
	
	
	function cambiarRevision(){
		

		
		$id_banca_compra_venta = $this->objParam->getParametro('id_banca_compra_venta');
		$revisado = $this->objParam->getParametro('revisado');
		
		$this->procedimiento='conta.ft_verificar_banca_compra_venta';
		$this->transaccion='CONTA_REVISAR_BANCA';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_banca_compra_venta','id_banca_compra_venta','int4');
		$this->setParametro('id_periodo','id_periodo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
		

	}
	
	function importar_txt(){
		
		
			$arra = array();

			$arregloFiles = $this->objParam->getArregloFiles();
			$ext = pathinfo($arregloFiles['archivo']['name']);
			$extension = $ext['extension'];
	
			$error = 'no';
			$mensaje_completo = '';
			//validar errores unicos del archivo: existencia, copia y extension
			if(isset($arregloFiles['archivo']) && is_uploaded_file($arregloFiles['archivo']['tmp_name'])){
				if ($extension != 'txt' && $extension != 'txt') {
					$mensaje_completo = "La extensión del archivo debe ser TXT";
					$error = 'error_fatal';
				}  
		  	    //upload directory  
			    $upload_dir = "/tmp/";  
			    //create file name  
			    $file_path = $upload_dir . $arregloFiles['archivo']['name'];  
			  	
			    //move uploaded file to upload dir  
			    if (!move_uploaded_file($arregloFiles['archivo']['tmp_name'], $file_path)) {	  
			        //error moving upload file  
			        $mensaje_completo = "Error al guardar el archivo txt en disco";
					$error = 'error_fatal';	  
			    }  
				
			} else {
				$mensaje_completo = "No se subio el archivo";
				$error = 'error_fatal';
			}
			
			//armar respuesta en error fatal
			if ($error == 'error_fatal') {
				
				$this->mensajeRes=new Mensaje();
				$this->mensajeRes->setMensaje('ERROR','ATCBancaCompraVenta.php',$mensaje_completo,
											$mensaje_completo,'control');
			//si no es error fatal proceso el archivo
			} else {
				
				
				$nombre_archivo = $arregloFiles['archivo']['name'];
				$partes = explode('_',$nombre_archivo);
				$fecha_archivo = $this->str_osplit($partes[2], 2);

				$fecha_archivo = '01/'.$fecha_archivo[0].'/'.$fecha_archivo[1];
				
				
				$this->aParam->addParametro('nombre_archivo', $nombre_archivo);
				$this->arreglo['nombre_archivo'] = $nombre_archivo;
				$this->aParam->addParametro('fecha_archivo', $fecha_archivo);
				$this->arreglo['fecha_archivo'] = $fecha_archivo;
				
				$lines = file($file_path);
				
				
				
				
				
				foreach ($lines as $line_num => $line) {
					$arr_temp = explode('|', $line);
					
					$arr_temp = $this->remove_utf8_bom($arr_temp);
					
					if($this->aParam->getParametro('tipo')=='Compras'){


					



						$arra[] = array(
							"modalidad_transaccion" => $arr_temp[0],
       						"fecha_documento" => $arr_temp[1],
       						"tipo_transaccion" => $arr_temp[2],
       						"nit_ci" => $arr_temp[3],
       						"razon" => $arr_temp[4],
       						"num_documento" => $arr_temp[5],
       						//"num_contrato" => $arr_temp[6],
       						"importe_documento" => $arr_temp[6],
       						"autorizacion" => $arr_temp[7],
       						"num_cuenta_pago" => $arr_temp[8],
       						"monto_pagado" => $arr_temp[9],
       						"monto_acumulado" => $arr_temp[10],
       						"nit_entidad" => $arr_temp[11],
       						"num_documento_pago" => $arr_temp[12],
       						"tipo_documento_pago" => $arr_temp[13],
       						"fecha_de_pago" => $arr_temp[14],
       						
						);
					}else if($this->aParam->getParametro('tipo')=='Ventas'){
						$arra[] = array(
							"modalidad_transaccion" => $arr_temp[0],
       						"fecha_documento" => $arr_temp[1],
       						"tipo_transaccion" => $arr_temp[2],
       						"nit_ci" => $arr_temp[3],
       						"razon" => $arr_temp[4],
       						"num_documento" => $arr_temp[5],
       						//"num_contrato" => $arr_temp[6],
       						"importe_documento" => $arr_temp[6],
       						"autorizacion" => $arr_temp[7],
       						"num_cuenta_pago" => $arr_temp[8],
       						"monto_pagado" => $arr_temp[9],
       						"monto_acumulado" => $arr_temp[10],
       						"nit_entidad" => $arr_temp[11],
       						"num_documento_pago" => $arr_temp[12],
       						"tipo_documento_pago" => $arr_temp[13],
       						"fecha_de_pago" => $arr_temp[14],
       						
						);
					}
					
					
					
					if (count($arr_temp) != 16) {
						$error = 'error';
						$mensaje_completo .= "No se proceso la linea: $line_num, por un error en el formato \n";
						
					} else {
						
						
						
						/*$this->objParam->addParametro('ci',$arr_temp[0]);
						$this->objParam->addParametro('valor',$arr_temp[1]);
						$this->objFunc=$this->create('MODColumnaValor');
						$this->res=$this->objFunc->modificarColumnaCsv($this->objParam);
						if ($this->res->getTipo() == 'ERROR') {
							$error = 'error';
							$mensaje_completo .= $this->res->getMensaje() . " \n";
						}*/
					}
				}
			}
			
			
			
		
			$arra_json = json_encode($arra);
		
			$this->aParam->addParametro('arra_json', $arra_json);
			$this->arreglo['arra_json'] = $arra_json;
			
			
			$this->procedimiento='conta.ft_banca_compra_venta_ime';
			$this->transaccion='CONTA_BANCA_IMP';
			$this->tipo_procedimiento='IME';
					
			//Define los parametros para la funcion
			$this->setParametro('arra_json','arra_json','text');
			$this->setParametro('tipo','tipo','varchar');
			$this->setParametro('id_periodo','id_periodo','int4');
			
			$this->setParametro('fecha_archivo','fecha_archivo','date');
			$this->setParametro('nombre_archivo','nombre_archivo','varchar');
	
			//Ejecuta la instruccion
			$this->armarConsulta();
			$this->ejecutarConsulta();
	
			//Devuelve la respuesta
			return $this->respuesta;
			
			
			
			
		
	}




	function remove_utf8_bom($text)
	{
	    $bom = pack('H*','EFBBBF');
	    $text = preg_replace("/^$bom/", '', $text);
	    return $text;
	}


	function str_osplit($string, $offset){
    return isset($string[$offset]) ? array(substr($string, 0, $offset), substr($string, $offset)) : false;
    }



	function listarDocumento(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_documento_endesis';
		$this->transaccion='FAC_DOC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		//$this->setCount(false);
        
        $this->setTipoRetorno('record');
		
		//BANCA_DOCUMENTOS
		
		
		if($_SESSION["BANCA_DOCUMENTOS"] == NULL){
			$_SESSION["BANCA_DOCUMENTOS"] = "pxp"; // si no tiene esa variable entrara por defecto en las tablas del pxp
		}
		
		$this->aParam->addParametro('banca_documentos', $_SESSION["BANCA_DOCUMENTOS"]);
		$this->arreglo['banca_documentos'] = $_SESSION["BANCA_DOCUMENTOS"];
			
		$this->setParametro('banca_documentos','banca_documentos','varchar');	
		
		//Definicion de la lista del resultado del query
		$this->captura('id_documento','int4');
		$this->captura('nro_autorizacion','varchar');
		$this->captura('nro_documento','bigint');
		$this->captura('fecha_documento','date');
		$this->captura('razon_social','varchar');
		$this->captura('nro_nit','varchar');
		
      $this->captura('sw_libro_compras','varchar');
	  $this->captura('importe_total','numeric');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

	function insertAuto(){
		
		$this->procedimiento='conta.ft_banca_compra_venta_ime';
		$this->transaccion='CONTA_BANCA_AUT';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('id_depto_conta','id_depto_conta','int4');
		


		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
		
	}
	
	function BorrarTodo(){
		
		$this->procedimiento='conta.ft_banca_compra_venta_ime';
		$this->transaccion='CONTA_BANCA_ELITO';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_depto_conta','id_depto_conta','int4');
				$this->setParametro('id_periodo','id_periodo','int4');
				$this->setParametro('tipo','tipo','varchar');
		
		


		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
		
	}

	function agregarListarNegra(){
		$this->procedimiento='conta.ft_banca_compra_venta_ime';
		$this->transaccion='CONTA_BANCA_ADDLN';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_banca_compra_venta','id_banca_compra_venta','int4');
		$this->setParametro('id_periodo','id_periodo','int4');

		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function insertarRetencionesPeriodo(){
		
		
		$this->procedimiento='conta.ft_banca_compra_venta_ime';
		$this->transaccion='CONTA_BANCA_INSRET';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('id_depto_conta','id_depto_conta','int4');
				
	
		$this->setParametro('numero_tramite','numero_tramite','varchar'); //el que envia
		
	
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
		
	}

	function clonar(){
		$this->procedimiento='conta.ft_banca_compra_venta_ime';
		$this->transaccion='CONTA_BANCA_CLON';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_banca_compra_venta','id_banca_compra_venta','int4');


		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	




	
			
}
?>