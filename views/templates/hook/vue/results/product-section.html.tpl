{*
 * Copyright (C) 2017-2018 thirty bees
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License (AFL 3.0)
 * that is bundled with this package in the file LICENSE.md
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/afl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to contact@thirtybees.com so we can send you a copy immediately.
 *
 * @author    thirty bees <contact@thirtybees.com>
 * @copyright 2017-2018 thirty bees
 * @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
 *}
<section v-if="query && total || fixedFilter && _.indexOf(['{Elasticsearch::getAlias('manufacturer')|escape:'javascript':'UTF-8'}', '{Elasticsearch::getAlias('supplier')|escape:'htmlall':'UTF-8'}', '{Elasticsearch::getAlias('category')|escape:'htmlall':'UTF-8'}', '{Elasticsearch::getAlias('categories')|escape:'htmlall':'UTF-8'}'], fixedFilter.aggregationCode) > -1">
  <h2 class="page-heading">
    <span v-if="query || fixedFilter && _.indexOf(['{Elasticsearch::getAlias('category')|escape:'javascript':'UTF-8'}', '{Elasticsearch::getAlias('categories')|escape:'htmlall':'UTF-8'}'], fixedFilter.aggregationCode) > -1">{l s='Products' mod='elasticsearch'}</span>
    <span v-else-if="fixedFilter.aggregationCode === '{Elasticsearch::getAlias('manufacturer')|escape:'javascript':'UTF-8'}'">{l s='List of products by manufacturer' mod='elasticsearch'} <strong>%% fixedFilter.filterName %%</strong></span>
    <span v-else-if="fixedFilter.aggregationCode === '{Elasticsearch::getAlias('supplier')|escape:'javascript':'UTF-8'}'">{l s='List of products by supplier:' mod='elasticsearch'} <strong>%% fixedFilter.filterName %%</strong></span>
    <span class="pull-right">
		<span v-if="parseInt(total.value, 10) === 1" class="heading-counter badge">{l s='There is' mod='elasticsearch'} %% total.value %% {l s='product.' mod='elasticsearch'}</span>
		<span v-else class="heading-counter badge">{l s='There are' mod='elasticsearch'} %% total.value %% {l s='products.' mod='elasticsearch'}</span>
	</span>
  </h2>
  <div class="content_sortPagiBar clearfix">
    <div class="form-inline sortPagiBar clearfix">
      <div id="product-list-switcher" class="form-group display">
        <label class="visible-xs">{l s='Display product list as:' mod='elasticsearch'}</label>
        <div class="btn-group" role="group" aria-label="Product list display type">
          <a id="es-grid"
             :class="'btn btn-default' + (layoutType === 'grid' ? ' selected active' : '')"
             rel="nofollow"
             @click="setLayoutType('grid')"
             title="{l s='Grid' mod='elasticsearch'}"
             style="cursor: pointer"
          >
            <i class="icon icon-fw icon-th"></i>
            <span class="visible-xs">{l s='Grid' mod='elasticsearch'}</span>
          </a>
          <a id="es-list"
             :class="'btn btn-default'  + (layoutType === 'list' ? ' selected active' : '')"
             rel="nofollow"
             @click="setLayoutType('list')"
             title="{l s='List' mod='elasticsearch'}"
             style="cursor: pointer"
          >
            <i class="icon icon-fw icon-bars"></i>
            <span class="visible-xs">{l s='List' mod='elasticsearch'}</span>
          </a>
		{if $is_logged}
			<a id="images" class="btn btn-default" rel="nofollow" title="{l s='Images'}">
			  <i class="icon icon-fw icon-picture-o" aria-hidden="true"></i>
			  <span class="visible-xs">{l s='Images'}</span>
			</a>
			<a id="dispo" class="btn btn-default" rel="nofollow" title="{l s='Dispo'}">
			  <i class="icon icon-fw icon-stack-overflow" aria-hidden="true"></i>
			  <span class="visible-xs">{l s='Dispo'}</span>
			</a>
			<a id="prix" class="btn btn-default {if (isset($showPrice) && $showPrice=='No')}active{/if}" rel="nofollow" title="{l s='Prix'}">
			  <i class="icon icon-fw icon-eur" aria-hidden="true"></i>
			  <span class="visible-xs">{l s='Prix'}</span>
			</a>
		{/if}
        </div>
      </div>

      <product-sort></product-sort>

      <div class="js-per-page form-group" v-if="!infiniteScroll">
        <label for="nb_item">{l s='Items per page:' mod='elasticsearch'}</label>
        <select @input="itemsPerPageHandler" class="form-control">
          <option v-for="itemsPerPage in itemsPerPageOptions"
                  :value.once="itemsPerPage"
                  :selected="itemsPerPage === limit"
                  :key="itemsPerPage"
          >%% itemsPerPage %%</option>
        </select>
      </div>
    </div>

    <div class="top-pagination-content form-inline clearfix" v-if="!infiniteScroll">
      <pagination :limit="limit" :offset="offset" :total="total"></pagination>

      <show-all></show-all>

      <product-count :limit="limit" :offset="offset" :total="total"></product-count>
    </div>
  </div>

  <ul :class="'product_list list-grid list-group ' + layoutType">
    <li v-for="result in results" class="ajax_block_product list-group-item col-xs-6 col-sm-4 col-md-3 col-lg-5ths" :key="result['_id']">
      <product-list-item :item="result"></product-list-item>
    </li>
  </ul>

  <div class="content_sortPagiBar" v-if="!infiniteScroll">
    <div class="bottom-pagination-content form-inline clearfix">
      <pagination :limit="limit" :offset="offset" :total="total"></pagination>
      <show-all></show-all>
      <product-count :limit="limit" :offset="offset" :total="total"></product-count>
    </div>
  </div>
  <infinite-loading @infinite="loadMoreProducts" v-if="infiniteScroll">
      <span slot="no-more">
        {l s='You\'ve reached the end of the list' mod='elasticsearch'}
      </span>
	  <span slot="no-results"></span>
  </infinite-loading>
</section>
<section v-else-if="!query">
  <div class="alert alert-warning">
    {l s='Please enter a search keyword' mod='elasticsearch'}
  </div>
</section>
<section v-else>
  <div class="alert alert-warning">
    {l s='No results found' mod='elasticsearch'}
  </div>
</section>
