<font size="10"><table width="100%" cellpadding="5px"  rules="cols" border="1">
	<tbody>
		
		<?php 
		  if ($this->cabecera[0]['id_moneda'] == $this->cabecera[0]['id_moneda_base']){
		 ?>
		<tr>
			<td width="60%" rowspan="2" align="center" ><b>DETALLE</b></td>
			<td width="40%" colspan="2"  align="center" class="td_currency"><span><b><?php  echo $this->cabecera[0]['desc_moneda']; ?></b></span></td>
		</tr>
		<tr>
			<td width="20%" align="center" class="td_currency"><span><b>DEBE</b></span></td>
			<td width="20%" align="center" class="td_currency"><span><b>HABER</b></span></td>
		</tr>
<?php	}
		else{  ?>
		<tr>
			<td width="50%" rowspan="2" align="center" ><b>DETALLE</b></td>
			<td width="25%" colspan="2"  align="center" class="td_currency"><span><b><?php  echo $this->cabecera[0]['desc_moneda']; ?></b></span></td>
			<td width="25%" colspan="2"  align="center" class="td_currency"><span><b><?php  echo $this->cabecera[0]['codigo_moneda_base']; ?></b></span></td>
		
		</tr>
		<tr>
			<td width="12.5%" align="center" class="td_currency"><span><b>DEBE</b></span></td>
			<td width="12.5%" align="center" class="td_currency"><span><b>HABER</b></span></td>
			<td width="12.5%" align="center" class="td_currency"><span><b>DEBE</b></span></td>
			<td width="12.5%" align="center" class="td_currency"><span><b>HABER</b></span></td>
		</tr>
			
		<?php } ?>	
</tbody>
</table></font>