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
		
		$this->setParametro('revisado','revisado','varchar');

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
		if($revisado == 'si'){
			$res = $this->link->prepare("update conta.tbanca_compra_venta set revisado = 'no' where id_banca_compra_venta = '$id_banca_compra_venta'");	
		}else if($revisado == 'no'){
			$res = $this->link->prepare("update conta.tbanca_compra_venta set revisado = 'si' where id_banca_compra_venta = '$id_banca_compra_venta'");	
		}
		$res->execute();
		$result = $res->fetchAll(PDO::FETCH_ASSOC);
		$this->respuesta = new Mensaje();
			$this->respuesta->setMensaje('EXITO', $this->nombre_archivo, 'La consulta se ejecuto con exito de insercion de nota', 'La consulta se ejecuto con exito', 'base', 'no tiene', 'no tiene', 'SEL', '$this->consulta', 'no tiene');
			$this->respuesta->setTotal(1);
			$this->respuesta->setDatos("correcto");
		return $this->respuesta;
	}
	
			
}
?>