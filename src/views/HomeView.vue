<template>
  <div class="product-body">
    <div class="header">
      <img src="@/assets/head.png" alt="" />
    </div>
    <div class="center">
      <h1>安般科技解决方案</h1>
      <h1>帮你管控整个软件生命周期中的安全和质量风险</h1>
      <div class="production-banner">
        <div
          v-for="(item, index) in projectList"
          :key="index"
          :style="{ cursor: item.link ? 'pointer' : 'not-allowed' }"
          @click="goto(item.link)"
        >
          <a>
            <div class="product-main">
              <div class="prodctions">
                <el-tooltip
                  v-if="!item.link"
                  effect="dark"
                  content="敬请期待"
                  placement="top"
                >
                  <img
                    :src="logoMap[item.abbreviation]"
                    :alt="item.abbreviation"
                  />
                </el-tooltip>
                <img
                  v-else
                  :src="logoMap[item.abbreviation]"
                  :alt="item.abbreviation"
                />
              </div>
              <span class="product-name"> {{ item.name }} </span>
              <span class="product-desc"> {{ item.desc }} </span>
            </div>
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { getProjectList } from "@/api/projects";

export default Vue.extend({
  name: "HomeView",
  data() {
    return {
      projectList: [],
      logoMap: {
        yh: require("@/assets/yh.svg"),
        yc: require("@/assets/yc.svg"),
        yz: require("@/assets/yz.svg"),
        ys: require("@/assets/ys.svg"),
        yj: require("@/assets/yj.svg"),
        yxiang: require("@/assets/yxiang.svg"),
        sca: require("@/assets/sca.svg"),
      },
    };
  },
  methods: {
    async initProjectList() {
      try {
        const res = await getProjectList();
        this.projectList = res.data.filter(
          (project: { disable: boolean }) => !project.disable
        );
      } catch (error) {
        console.log(error);
      }
    },
    goto(link: string) {
      if (!link) return;
      const newTab = window.open("about:blank");
      if (newTab) {
        newTab.location.href = link;
      }
    },
  },
  mounted() {
    this.initProjectList();
  },
});
</script>

<style lang="stylus" scoped>
* {
  padding: 0px;
  margin: 0px;
}

.product-body {
  min-width: 1200px;
  height: 100vh;
  display: flex;
  flex-direction: column;
  margin: auto;
  background-color: #000101;
  overflow: hidden;
  background-image: url("@/assets/background.png");
  background-size: 100% 100%;
  background-repeat: no-repeat;
}

.production-banner {
  width: 896px;
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  margin-top: 44px;
}

.header {
  width: 100%;
  height: 59px;
  display: flex;
  align-items: center;
}

.header img {
  width: 200px;
  height: 28px;
  margin-left: 120px;
}

.center {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  margin: auto;
}

h1 {
  font-family: 'Source Han Sans CN';
  font-style: normal;
  font-weight: 700;
  font-size: 38px;
  line-height: 46px;
  text-align: center;
  letter-spacing: -0.4px;
  color: #ffffff;
}

.product-main {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin: 12px;

  &:hover {
    .product-name, .product-desc {
      font-style: normal;
      font-weight: 700;
      font-size: 14px;
      line-height: 22px;
      text-align: center;
      color: #ffffff;
      opacity: 1;
    }

    .prodctions {
      background: linear-gradient(43.91deg, #181d4e 2.48%, #2a2aaf 104.46%);
    }
  }
}

.product-desc {
  font-style: normal;
  font-weight: 400;
  font-size: 14px;
  line-height: 22px;
  text-align: center;
  color: #ffffff;
  mix-blend-mode: normal;
  opacity: 0.7;
}

.prodctions {
  width: 200px;
  height: 120px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #2c3049;
  border-radius: 10px;
}

.product-name {
  margin-top: 16px;
  font-style: normal;
  font-weight: 400;
  font-size: 14px;
  line-height: 22px;
  text-align: center;
  color: #ffffff;
  mix-blend-mode: normal;
  opacity: 0.7;
}
</style>
