<?php
/**
 *@package pXP
 *@file cabeceraDetallephp
 *@author  (admin)
 *@date 29-08-2013 00:28:30
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 *
HISTORIAL DE MODIFICACIONES:
ISSUE        FORK			FECHA:		      AUTOR                 DESCRIPCION
#33     ETR     	10/02/2019		  Miguel Mamani	  		Mostrar moneda $us en reporte comprobante
 */
?>
<font size="8"><table width="100%" cellpadding="5px"  rules="cols" border="1">
	<tbody>
		
		<?php
            //#33  
		  if ($this->cabecera[0]['id_moneda'] == $this->cabecera[0]['id_moneda_base']){
		 ?>
		<tr>
			<td width="45%" rowspan="2" align="center" ><b>DETALLE</b></td>
			<td width="33%" colspan="2"  align="center" class="td_currency"><span><b><?php  echo $this->cabecera[0]['desc_moneda']; ?></b></span></td>
            <td width="22%" colspan="2"  align="center" class="td_currency"><span><b><?php  echo $this->cabecera[0]['codigo_moneda_base']; ?></b></span></td>
        </tr>
		<tr>
			<td width="11%" align="center" class="td_currency"><span><b>Ejecución</b></span></td>
			<td width="11%" align="center" class="td_currency"><span><b>Debe</b></span></td>
			<td width="11%" align="center" class="td_currency"><span><b>Haber</b></span></td>
            <td width="11%" align="center" class="td_currency"><span><b>Debe</b></span></td>
            <td width="11%" align="center" class="td_currency"><span><b>Haber</b></span></td>
		</tr>
<?php	}
		else{  ?>
		<tr>
			<td width="45%" rowspan="2" align="center" ><b>DETALLE</b></td>
			<td width="33%" colspan="2"  align="center" class="td_currency"><span><b><?php  echo $this->cabecera[0]['desc_moneda']; ?></b></span></td>
			<td width="22%" colspan="2"  align="center" class="td_currency"><span><b><?php  echo $this->cabecera[0]['codigo_moneda_base']; ?></b></span></td>
		
		</tr>
		<tr>
			<td width="11%" align="center" class="td_currency"><span><b>Ejecución</b></span></td>
			<td width="11%" align="center" class="td_currency"><span><b>Debe</b></span></td>
			<td width="11%" align="center" class="td_currency"><span><b>Haber</b></span></td>
			<td width="11%" align="center" class="td_currency"><span><b>Debe</b></span></td>
			<td width="11%" align="center" class="td_currency"><span><b>Haber</b></span></td>
		</tr>
			
		<?php } ?>	
</tbody>
</table></font>