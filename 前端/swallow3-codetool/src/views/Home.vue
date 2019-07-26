<template>
  <Layout>
    <Header class="title">
      <img src="~@/assets/fly.png">
      <span>Swallow3代码生成(请使用chrome)</span>
    </Header>
    <Content>
      <div style="background:#eee;padding: 20px">
        <Row>
        <Col :span="11">
        <Card :bordered="false">
            <p slot="title">实体描述文件</p>
            <p>
              <input type="file" placeholder="选择要上传的json文件" @change="onFileChange" >

            </p>
        </Card>
        </Col>

        <Col :span="11" :offset="1">
        <Card :bordered="false">
            <p slot="title" class="actionpane">下载代码文件</p>

              生成包名称
              <Input class="actionbutton" style="width:300px" v-model="packagePath" />
              <Button class="actionbutton" type="info" @click="downloadControl">下载Control类文件</Button>
              <Button class="actionbutton" type="info" @click="downloadtsapi">下载前端api脚本</Button>
              <Button class="actionbutton" type="info" @click="downloadtablecols">下载前端表格列定义脚本</Button>

        </Card>
        </Col>
        </Row>
        <Row>
          <Alert type="error" v-if="iserror">{{errMsg}}</Alert>
        </Row>
    </div>
    </Content>
  </Layout>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import { downfile, saveFile } from '@/libs/request'

@Component({
  components: {
  }
})
export default class Home extends Vue {
  jsonData?:string=''
  packagePath?:string=''
  iserror:boolean=false
  errMsg:string=''
  file?:any

  onFileChange (event:any) {
    this.file = event.target.files[0]
    this.readJsonFile()
  }

  // 读取json文件
  readJsonFile ():Promise<any> {
    return new Promise<any>((resolve, reject) => {
      let reader:FileReader = new FileReader()

      reader.onload = (e:ProgressEvent) => {
        let res:string = (e.target as any).result
        if (res) {
          let ob = JSON.parse(res)
          resolve(ob)
        }
      }
      reader.onerror = (e:any) => {
        reject(e)
      }

      reader.readAsText(this.file, 'UTF-8')
    })
  }

  // 下载后台control类
  downloadControl () {
    this.iserror = false
    if (!this.file) {
      this.$Message.error('请先选择实体的描述')
      return
    }
    if (!this.packagePath) {
      this.$Message.error('请先填写生成control类的包名')
    }

    this.readJsonFile().then((data) => {
      console.log('%o', data)

      downfile({
        url: '/api/control',
        method: 'post',
        data: {
          entityinfo: data,
          packagePath: this.packagePath
        }
      }, 'txt/plain').then((filedata) => {
        saveFile(filedata, data.name + 'Control.java')
      }).catch(err => {
        this.iserror = true
        this.errMsg = '生成错误:' + err
      })
    }).catch(() => {
      this.iserror = true
      this.errMsg = '生成错误:读取文件错误'
    })
  }

  // 生成tsapi
  downloadtsapi () {
    this.iserror = false
    if (!this.file) {
      this.$Message.error('请先选择实体的描述')
      return
    }

    this.readJsonFile().then((data) => {
      console.log('%o', data)
      downfile({
        url: '/api/tsapi',
        method: 'post',
        data: data
      }, 'txt/plain').then((filedata) => {
        saveFile(filedata, data.name + '.ts')
      }).catch(err => {
        this.iserror = true
        this.errMsg = '生成错误:' + err
      })
    }).catch(() => {
      this.iserror = true
      this.errMsg = '生成错误:读取文件错误'
    })
  }

  // 下载表格定义类
  downloadtablecols () {
    this.iserror = false
    if (!this.file) {
      this.$Message.error('请先选择实体的描述')
      return
    }

    this.readJsonFile().then((data) => {
      console.log('%o', data)
      downfile({
        url: '/api/tstablecols',
        method: 'post',
        data: data
      }, 'txt/plain').then((filedata) => {
        saveFile(filedata, data.name + 'TableColDefine.ts')
      }).catch(err => {
        this.iserror = true
        this.errMsg = '生成错误:' + err
      })
    }).catch(() => {
      this.iserror = true
      this.errMsg = '生成错误:读取文件错误'
    })
  }
}
</script>
<style lang="less" scoped>
.title{
  color: white;
  font-family: "Helvetica Neue",Helvetica,"PingFang SC","Hiragino Sans GB","Microsoft YaHei","微软雅黑",Arial,sans-serif;
  font-size: 35px;
  display: flex;
  align-content: center;

  img{
    width: 60px;
    height: 60px;
  }
  span{
    height: 60px;
    line-height: 60px;
  }
}
.actionpane{
  display: flex;
  flex-wrap: wrap;
  flex: column;
  justify-content: space-between;
  width: 100%;

}
.actionbutton{
    margin: 5px;
  }
</style>
