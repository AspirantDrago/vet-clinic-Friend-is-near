<template>
  <h2 class="text-center">
    <p>Популярные услуги</p>
  </h2>
  <div class="col">
    <div class="col">
      <UIFormInput label="Поиск:" name="search" input-type="text" @changeInput="setForm" />
      <br>
    </div>
    <div v-if="loadingServices" class="row">
      <div class="d-flex justify-content-center">
        <div class="spinner-border" role="status">
          <span class="visually-hidden">Загрузка...</span>
        </div>
      </div>
    </div>
    <div v-else-if="services && services.length > 0" class="row">
      <div
        class="service-component text-center col-sum-12 col-md-6 col-lg-3"
        v-for="service in services"
        :key="service.id"
        @click="handlerClickOnCardService(service)"
        data-bs-toggle="modal" data-bs-target="#ModalServiceInfo"
      >
        <p>
          <img class="service-component__image" :src="service.img" :alt="service.title">
        </p>
        <p>
          {{ service.title }}
        </p>
      </div>
    </div>
    <div v-else class="row">
      <p>Ничего не найдено</p>
    </div>
  </div>
  <ModalServiceInfo :service="modalService" />
</template>

<script>
import UIFormInput from "@/components/UI/UIFormInput";
import ModalServiceInfo from "@/components/UI/ModalServiceInfo";

export default {
  name: "ServicesBlock",
  components: {
    UIFormInput,
    ModalServiceInfo
  },
  data () {
    return {
      valueSearch: '',
      modalService: {},
    };
  },
  props: {
    hasSearch: {
      type: Boolean,
      required: false,
      default: false,
    }
  },
  mounted () {
    if (this.services.length === 0) {
      this.$store.dispatch('loadServices');
    }
  },
  computed: {
    services: function () {
      var data = this.$store.state.services;
      if (this.valueSearch) {
        data = data.filter(elem => elem.title.toLowerCase().includes(this.valueSearch));
      }
      return data;
    },
    loadingServices: function () {
      return this.$store.state.loadingServices;
    },
  },
  methods: {
    setForm (event) {
      this.valueSearch = event.value.trim().toLowerCase();
    },
    handlerClickOnCardService(service) {
      this.modalService = service;
    },
  }
}
</script>

<style scoped lang="scss">
  $animationShift: 10px;
  $animationDuration: 0.5s;

  .service-component {
    position: relative;
    transition-property: top;
    transition-duration: $animationDuration;
    top: 0;
    cursor: pointer;
    img, p {
      transition-duration: $animationDuration;
    }
    img {
      transition-property: box-shadow;
    }
    p {
      transition-property: text-shadow;
    }
    &:hover {
      top: -10px;
      img {
        box-shadow: 0 10px 10px rgba(0, 0, 0, 0.5);
      }
      p {
        text-shadow: 0 10px 10px rgba(0, 0, 0, 0.5);
      }
    }
  }

  .service-component__image {
    width: 300px;
    height: 300px;
    object-fit: cover;
    border-radius: 30px;
  }
</style>
