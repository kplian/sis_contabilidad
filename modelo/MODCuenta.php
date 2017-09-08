<?php
/**
*@package pXP
*@file MODCuenta.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-02-2013 15:04:03
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCuenta extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCuenta(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.f_cuenta_sel';
		$this->transaccion='CONTA_CTA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		$this->setParametro('filtro_ges','filtro_ges','varchar');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		
		 
		//Definicion de la lista del resultado del query
		$this->captura('id_cuenta','int4');
		$this->captura('id_usuario_reg','int4');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_reg','timestamp');
        $this->captura('fecha_mod','timestamp');
        $this->captura('estado_reg','varchar');
        $this->captura('id_empresa','int4');
        $this->captura('id_parametro','int4');
        $this->captura('id_cuenta_padre','int4');
        $this->captura('nro_cuenta','varchar');
        $this->captura('id_gestion','int4');
        $this->captura('id_moneda','int4');
        $this->captura('nombre_cuenta','varchar');
        $this->captura('desc_cuenta','varchar');
        $this->captura('nivel_cuenta','int4');
        $this->captura('tipo_cuenta','varchar');
        $this->captura('sw_transaccional','varchar');
        $this->captura('sw_auxiliar','varchar');
        $this->captura('tipo_cuenta_pat','varchar');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('desc_moneda','varchar');
        $this->captura('gestion','int4');
		$this->captura('sw_control_efectivo','varchar');
		$this->captura('tipo_act','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

 function listarCuentaArb(){
		    //Definicion de variables para ejecucion del procedimientp
		    $this->procedimiento='conta.f_cuenta_sel';
		    $this-> setCount(false);
		    $this->transaccion='CONTA_CTA_ARB_SEL';
		    $this->tipo_procedimiento='SEL';//tipo de transaccion
		    
		    $id_padre = $this->objParam->getParametro('id_padre');
		    
		    $this->setParametro('id_padre','id_padre','varchar'); 
			$this->setParametro('id_gestion','id_gestion','integer');       
		            
		    //Definicion de la lista del resultado del query
		     $this->captura('id_cuenta','int4');
		     $this->captura('id_cuenta_padre','int4');
		     $this->captura('nombre_cuenta','varchar');
		     $this->captura('tipo_nodo','varchar');
			 $this->captura('nro_cuenta','varchar');
			 $this->captura('desc_cuenta','varchar');
			 $this->captura('id_moneda','integer');
			 $this->captura('desc_moneda','varchar');
			 $this->captura('tipo_cuenta','varchar');
			 $this->captura('sw_auxiliar','varchar');
			 $this->captura('tipo_cuenta_pat','varchar');
			 $this->captura('sw_transaccional','varchar');
			 $this->captura('id_gestion','integer');
			 $this->captura('valor_incremento','varchar');
			 $this->captura('eeff','varchar');
			 $this->captura('sw_control_efectivo','varchar');
			 $this->captura('id_config_subtipo_cuenta','int4');
			 $this->captura('desc_csc','varchar');
			 $this->captura('tipo_act','varchar');
			
			 
		     //Ejecuta la instruccion
		     $this->armarConsulta();
			 $this->ejecutarConsulta();
		    
		    return $this->respuesta;       
    }
			
	function insertarCuenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.f_cuenta_ime';
		$this->transaccion='CONTA_CTA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_padre','id_cuenta_padre','varchar');
		$this->setParametro('nro_cuenta','nro_cuenta','varchar');
		$this->setParametro('nombre_cuenta','nombre_cuenta','varchar');
		$this->setParametro('desc_cuenta','desc_cuenta','varchar');
		$this->setParametro('sw_auxiliar','sw_auxiliar','varchar');
		$this->setParametro('tipo_cuenta','tipo_cuenta','varchar');
		$this->setParametro('tipo_cuenta_pat','tipo_cuenta_pat','varchar');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('sw_transaccional','sw_transaccional','varchar');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('eeff','eeff','varchar');
		$this->setParametro('valor_incremento','valor_incremento','varchar');
		$this->setParametro('sw_control_efectivo','sw_control_efectivo','varchar');
		$this->setParametro('id_config_subtipo_cuenta','id_config_subtipo_cuenta','int4');
		$this->setParametro('tipo_act','tipo_act','varchar');
		
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCuenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.f_cuenta_ime';
		$this->transaccion='CONTA_CTA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('id_cuenta_padre','id_cuenta_padre','varchar');
		$this->setParametro('nro_cuenta','nro_cuenta','varchar');
		$this->setParametro('nombre_cuenta','nombre_cuenta','varchar');
		$this->setParametro('desc_cuenta','desc_cuenta','varchar');
		$this->setParametro('sw_auxiliar','sw_auxiliar','varchar');
		$this->setParametro('tipo_cuenta','tipo_cuenta','varchar');
		$this->setParametro('tipo_cuenta_pat','tipo_cuenta_pat','varchar');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('sw_transaccional','sw_transaccional','varchar');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('eeff','eeff','varchar');
		$this->setParametro('valor_incremento','valor_incremento','varchar');
		$this->setParametro('sw_control_efectivo','sw_control_efectivo','varchar');
		$this->setParametro('id_config_subtipo_cuenta','id_config_subtipo_cuenta','int4');
		$this->setParametro('tipo_act','tipo_act','varchar');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCuenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.f_cuenta_ime';
		$this->transaccion='CONTA_CTA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cuenta','id_cuenta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function listarPlanCuentas(){
	    //Definicion de variables para ejecucion del procedimientp
	    $this->procedimiento='conta.f_cuenta_sel';
	    $this-> setCount(false);
	    $this->transaccion='CONTA_PLANCNT_SEL';
	    $this->tipo_procedimiento='SEL';//tipo de transaccion
	    
	    $this->setParametro('id_gestion','id_gestion','integer');       
	            
	    //Definicion de la lista del resultado del query
	     $this->captura('id_cuenta','int4');     
		 $this->captura('nro_cuenta','varchar');
		 $this->captura('nombre_cuenta','varchar');
		 $this->captura('id_cuenta_padre','int4');
	     
	    //Ejecuta la instruccion
	    $this->armarConsulta();
	    $this->ejecutarConsulta();
	    
	    return $this->respuesta;       
    }
   
   function listarBalanceGeneral(){
	    //Definicion de variables para ejecucion del procedimientp
	    $this->procedimiento='conta.f_balance';
	    $this-> setCount(false);
		$this->setTipoRetorno('record');
	    $this->transaccion='CONTA_BALANCE_SEL';
	    $this->tipo_procedimiento='SEL';//tipo de transaccion
	    
	    $this->setParametro('desde','desde','date');
		$this->setParametro('hasta','hasta','date');
		$this->setParametro('nivel','nivel','integer');
		$this->setParametro('id_deptos','id_deptos','varchar'); 		
		$this->setParametro('tipo_cuenta','tipo_cuenta','varchar'); 
		$this->setParametro('incluir_cierre','incluir_cierre','varchar');  
		$this->setParametro('tipo_balance','tipo_balance','varchar'); 
		$this->setParametro('incluir_sinmov','incluir_sinmov','varchar');      
	            
	    //Definicion de la lista del resultado del query
	     $this->captura('id_cuenta','int4');     
		 $this->captura('nro_cuenta','varchar');
		 $this->captura('nombre_cuenta','varchar');
		 $this->captura('id_cuenta_padre','int4');
		 $this->captura('monto','numeric');
		 $this->captura('nivel','int4');
		 $this->captura('tipo_cuenta','varchar');
		 $this->captura('movimiento','varchar');
		 
		//Ejecuta la instruccion
	    $this->armarConsulta();
		//echo $this->getConsulta();
		//exit;
	    $this->ejecutarConsulta();
	    
	    return $this->respuesta;       
 }

   function listarDetResultados(){
	    //Definicion de variables para ejecucion del procedimientp
	    $this->procedimiento='conta.f_resultados';
	    $this-> setCount(false);
		$this->setTipoRetorno('record');
	    $this->transaccion='CONTA_RESUTADO_SEL';
	    $this->tipo_procedimiento='SEL';//tipo de transaccion
	    
	    $this->setParametro('desde','desde','date');
		$this->setParametro('hasta','hasta','date');
		$this->setParametro('id_resultado_plantilla','id_resultado_plantilla','integer');
		$this->setParametro('id_deptos','id_deptos','varchar'); 
		$this->setParametro('extendido','extendido','varchar');
		$this->setParametro('incluir_sinmov','incluir_sinmov','varchar');        
	            
	    //Definicion de la lista del resultado del query
	    $this->captura('subrayar','varchar'); 
        $this->captura('font_size','varchar'); 
        $this->captura('posicion','varchar'); 
        $this->captura('signo','varchar'); 
        $this->captura('id_cuenta','int4'); 
        $this->captura('desc_cuenta','varchar'); 
        $this->captura('codigo_cuenta','varchar'); 
        $this->captura('codigo','varchar'); 
        $this->captura('origen','varchar'); 
        $this->captura('orden','numeric'); 
        $this->captura('nombre_variable','varchar'); 
        $this->captura('montopos','int4'); 
        $this->captura('monto','numeric'); 
        $this->captura('id_resultado_det_plantilla','int4'); 
        $this->captura('id_cuenta_raiz','int4'); 
		
		$this->captura('visible','varchar'); 
		$this->captura('incluir_cierre','varchar'); 
		$this->captura('incluir_apertura','varchar'); 
		
		$this->captura('negrita','varchar'); 
		$this->captura('cursiva','varchar'); 
		$this->captura('espacio_previo','int4'); 
		
		$this->captura('id','int4');
		$this->captura('plantilla','varchar');
		$this->captura('nombre_columna','varchar');
		
		

		 
		//Ejecuta la instruccion
	    $this->armarConsulta();
		//echo $this->getConsulta();
		//exit;
	    $this->ejecutarConsulta();
	    
	    return $this->respuesta;       
   }
   
   function clonarCuentasGestion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.f_cuenta_ime';
		$this->transaccion='CONTA_CLONARCUE_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_gestion_des','id_gestion_des','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function listarBalanceOrdenes(){
	    //Definicion de variables para ejecucion del procedimientp
	    $this->procedimiento='conta.f_balance_ot';
	    $this-> setCount(false);
		$this->setTipoRetorno('record');
	    $this->transaccion='CONTA_BALOT_SEL';
	    $this->tipo_procedimiento='SEL';//tipo de transaccion
	    
	    $this->setParametro('desde','desde','date');
		$this->setParametro('hasta','hasta','date');
		$this->setParametro('nivel','nivel','integer');
		$this->setParametro('id_deptos','id_deptos','varchar');
		$this->setParametro('id_ordenes_trabajos','id_ordenes_trabajos','varchar'); 		
		$this->setParametro('tipo','tipo','varchar'); 
		$this->setParametro('incluir_cierre','incluir_cierre','varchar');  
		$this->setParametro('tipo_balance','tipo_balance','varchar'); 
		$this->setParametro('incluir_sinmov','incluir_sinmov','varchar');      
	            
	    //Definicion de la lista del resultado del query
	     $this->captura('id_orden_trabajo','int4');     
		 $this->captura('codigo','varchar');
		 $this->captura('desc_orden','varchar');
		 $this->captura('id_orden_trabajo_fk','int4');
		 $this->captura('monto','numeric');
		 $this->captura('monto_mt','numeric');
		 $this->captura('monto_debe','numeric');
		 $this->captura('monto_mt_debe','numeric');
		 $this->captura('monto_haber','numeric');
		 $this->captura('monto_mt_haber','numeric');
		 $this->captura('nivel','int4');
		 $this->captura('tipo','varchar');
		 $this->captura('movimiento','varchar');
		 
 
		 
		//Ejecuta la instruccion
	    $this->armarConsulta();
		//echo $this->getConsulta();
		//exit;
	    $this->ejecutarConsulta();
	    
	    return $this->respuesta;       
 }

  function listarBalanceTipoCC(){
	    //Definicion de variables para ejecucion del procedimientp
	    $this->procedimiento='conta.f_balance_tcc';
	    $this-> setCount(false);
		$this->setTipoRetorno('record');
	    $this->transaccion='CONTA_BALTCC_SEL';
	    $this->tipo_procedimiento='SEL';//tipo de transaccion
	    
	    $this->setParametro('desde','desde','date');
		$this->setParametro('hasta','hasta','date');
		$this->setParametro('nivel','nivel','integer');
		$this->setParametro('id_deptos','id_deptos','varchar');
		$this->setParametro('id_tipo_ccs','id_tipo_ccs','varchar'); 		
		$this->setParametro('tipo','tipo','varchar'); 
		$this->setParametro('incluir_cierre','incluir_cierre','varchar');  
		$this->setParametro('tipo_balance','tipo_balance','varchar'); 
		$this->setParametro('incluir_sinmov','incluir_sinmov','varchar'); 
		
		$this->setParametro('incluir_adm','incluir_adm','varchar'); 
		$this->setParametro('importe','importe','varchar');
		$this->setParametro('moneda','moneda','varchar');
		     
	            
	    //Definicion de la lista del resultado del query
	     $this->captura('id_tipo_cc','int4');     
		 $this->captura('codigo','varchar');
		 $this->captura('descripcion','varchar');
		 $this->captura('id_tipo_cc_fk','int4');
		 $this->captura('monto','numeric');
		 $this->captura('monto_mt','numeric');
		 $this->captura('monto_debe','numeric');
		 $this->captura('monto_mt_debe','numeric');
		 $this->captura('monto_haber','numeric');
		 $this->captura('monto_mt_haber','numeric');
		 $this->captura('nivel','int4');
		 $this->captura('tipo','varchar');
		 $this->captura('movimiento','varchar');
		 

		//Ejecuta la instruccion
	    $this->armarConsulta();
		//echo $this->getConsulta();
		//exit;
	    $this->ejecutarConsulta();
	    
	    return $this->respuesta;       
 }


			
}
?>
