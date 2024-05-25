import UIKit
struct MovieData : Codable {
    let boxOfficeResult : BoxOfficeResult
}
struct BoxOfficeResult : Codable {
    let dailyBoxOfficeList : [DailyBoxOfficeList]
}
struct DailyBoxOfficeList : Codable {
    let movieNm : String
    let audiCnt : String
    let audiAcc : String
    let rank : String
}
let name = ["범죄도시4", "쿵푸팬더4", "파묘", "첼린저스", "남은 인생 10년", "고스트 버스터즈 : 오싹한 뉴욕", "듄 : 파트2", "소풍", "레옹", "몬스터 프렌즈"]
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var table: UITableView!
    var movieData : MovieData?
    var movieURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=fb3080d07bf3c3191907fc4269366065&targetDt="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        movieURL += getYesterdayString()
        getData()
    }
    
    func getYesterdayString() -> String {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: yesterday)
    }
    
    
    func getData() {
        guard let url = URL(string: movieURL) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!)
                return
            }
            
            guard let JSONdata = data else { return }
            print(JSONdata)
            // let dataString = String(data: JSONdata, encoding: .utf8)
            // print(dataString!)
            
            let decode = JSONDecoder()
            do {
                let decodedData = try decode.decode(MovieData.self, from: JSONdata)
                print(decodedData.boxOfficeResult.dailyBoxOfficeList[0].movieNm)
                self.movieData = decodedData
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell
        guard let mRank = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].rank
        else { return UITableViewCell() }
        guard let mName = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].movieNm
        else  { return UITableViewCell() }
        
        cell.movieName.text = "[\(mRank)위] \(mName)"
        
        if let aAcc = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].audiAcc {
              let numF = NumberFormatter()
              numF.numberStyle = .decimal
              let aAcc1 = Int(aAcc)!
              let result = numF.string(for: aAcc1)!+"명"
              cell.audiAccumulate.text = "누적 : \(result)"
              //cell.audiCount.text = "어제:\(aCnt)명"
          }
        if let aCnt = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].audiCnt {
            let numF = NumberFormatter()
            numF.numberStyle = .decimal
            let aAcc1 = Int(aCnt)!
            let result = numF.string(for: aAcc1)!+"명"
            cell.audiCount.text = "어제 : \(result)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "🍿박스오피스(영화진흥위원회제공:"+getYesterdayString()+")🍿"
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "🎵 by P_Piano🎵"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.description)
    }
    
    
}

