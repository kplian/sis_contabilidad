<font size="8"><table width="100%" cellpadding="5px"  rules="cols" border="1">
	<tbody>
		
		<?php 
		  if ($this->cabecera[0]['id_moneda'] == $this->cabecera[0]['id_moneda_base']){
		 ?>
		<tr>
			<td width="55%" rowspan="2" align="center" ><b>DETALLE</b></td>
			<td width="45%" colspan="3"  align="center" class="td_currency"><span><b><?php  echo $this->cabecera[0]['desc_moneda']; ?></b></span></td>
		</tr>
		<tr>
			<td width="15%" align="center" class="td_currency"><span><b>Ejecución</b></span></td>
			<td width="15%" align="center" class="td_currency"><span><b>Debe</b></span></td>
			<td width="15%" align="center" class="td_currency"><span><b>Haber</b></span></td>
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