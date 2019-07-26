import axios, { AxiosRequestConfig } from 'axios'

/**
 * 下载文件
 */
export function downfile (req:AxiosRequestConfig, contextType:string) {
  return new Promise<Blob>((resolve, reject) => {
    let reqData = req

    // 根据环境变量取得服务地址
    let url = req.url as string

    url = url.startsWith('/') ? url : '/' + url
    reqData.url = url
    reqData.responseType = 'blob'

    // 在请求中添加token信息

    console.log('向服务器发送数据请求:%o', reqData)

    axios.request(reqData).then(response => {
      console.log('收到服务请求的数据:%o', response)

      resolve(new Blob([response.data], { type: contextType }))
    }).catch(err => {
      console.error('收到服务回复的数据请求错误:%o', err.message)
      reject(err)
    })
  })
}

// 保存下载文件
export function saveFile (data:Blob, fileName:string) {
  if (window.navigator.msSaveBlob) {
    navigator.msSaveBlob(data, fileName)
  } else {
    const url = URL.createObjectURL(data)
    const link = document.createElement('a')
    link.href = url
    link.download = fileName
    link.click()
  }
}
