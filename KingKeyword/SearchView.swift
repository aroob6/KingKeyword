//
//  SearchView.swift
//  TopKeyword
//
//  Created by 이보라 on 2022/11/11.
//

import SwiftUI
import GoogleMobileAds

struct SearchBar: View {
    @Binding var text: String
    @Binding var empty: Bool
    
    var body: some View {
        HStack {
            HStack {
                TextField("키워드 검색", text: $text)
                    .foregroundColor(.primary)
                    .frame(height: 30)
                Image(systemName: "magnifyingglass")
                    .onChange(of: text) { newValue in
                        if newValue.isEmpty {
                            empty = true
                        }
                        else {
                            empty = false
                        }
                    }
                if !text.isEmpty {
                    Button(action: { self.text = ""}) {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
                else {
                    EmptyView()
                }
                
                Image(systemName: "")
            }
            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
            .border(Color.mainColor)
            .foregroundColor(Color.mainColor)
            //            .background(Color(.secondarySystemBackground))
        }
        .padding(.horizontal)
    }
}

struct SearchView: View {
    @State private var searchText = ""
    @State private var emptyCheck = false
    @StateObject var naverApiviewModel = NaverApiViewModel()
    @StateObject var naverAdApiviewModel = NaverAdApiViewModel()
    
    var body: some View {
        VStack {
            BannerAdView().frame(height: 70).padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
            Spacer()
            Text("킹키워드")
                .font(Font.title)
                .fontWeight(Font.Weight.bold)
                .foregroundColor(Color.mainColor)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            Text("검색 시 엔터키를 눌러주세요")
                .font(Font.caption2)
                .fontWeight(Font.Weight.semibold)
                .foregroundColor(.gray)
            SearchBar(text: $searchText, empty: $emptyCheck)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                .onSubmit {
                    //공백제거
                    let trimText = searchText.trimmingCharacters(in: .whitespaces).components(separatedBy: " ").joined().uppercased()
                    naverApiviewModel.getBlog(query: searchText)
                    naverApiviewModel.getCafe(query: searchText)
                    naverAdApiviewModel.getRelKwdStat(query: trimText)
                }
                .onChange(of: emptyCheck, perform: { newValue in
                    if newValue {
                        naverApiviewModel.reset()
                        naverAdApiviewModel.reset()
                        return
                    }
                })
            
            VStack {
                let trimText = searchText.trimmingCharacters(in: .whitespaces)
                if trimText.count == 0 {
                    EmptyView()
                }
                else {
                    List {
                        VStack() {
                            let blog = naverApiviewModel.blogs.total
                            let cafe = naverApiviewModel.cafes.total
                            let allDoc = blog + cafe
                            let pcAmount = naverAdApiviewModel.keywordList.keywordList[0].monthlyPcQcCnt.num
                            let mobileAmount = naverAdApiviewModel.keywordList.keywordList[0].monthlyMobileQcCnt.num
                            let allSearch = pcAmount + mobileAmount
                            let blogPersent = Double(blog) / Double(allSearch)
                            let cafePersent = Double(cafe) / Double(allSearch)
                            
                            let pcAvgClick = naverAdApiviewModel.keywordList.keywordList[0].monthlyAvePcClkCnt
                            let mobileAvgClick = naverAdApiviewModel.keywordList.keywordList[0].monthlyAveMobileClkCnt
                            let compIdx = naverAdApiviewModel.keywordList.keywordList[0].compIdx
                            
                            VStack {
                                Spacer()
                                TitleTextView(title: searchText)
                                Spacer()
                                HStack() {
                                    Spacer()
                                    TitleTextView(title: "블로그 비율\n \(String(format: "%.3f", blogPersent))").foregroundColor(Color.mainColor).multilineTextAlignment(.center)
                                    Spacer()
                                    TitleTextView(title: "카페 비율\n \(String(format: "%.3f", cafePersent))").foregroundColor(Color.subColor).multilineTextAlignment(.center)
                                    Spacer()
                                }
                                Spacer()
                            }
                            
                            Spacer()
                            HStack {
                                TypeView(title: "블로그글 수", content: "\(blog.numberFormatter())")
                                Spacer()
                                TypeView(title: "카페글 수", content: "\(cafe.numberFormatter())")
                                Spacer()
                                TypeView(title: "총 문서 수", content: "\(allDoc.numberFormatter())")
                            }
                            Spacer()
                            HStack {
                                TypeView(title: "PC 검색 수", content: "\(pcAmount.numberFormatter())")
                                Spacer()
                                TypeView(title: "모바일 검색 수", content: "\(mobileAmount.numberFormatter())")
                                Spacer()
                                TypeView(title: "총 검색 수", content: "\(allSearch.numberFormatter())")
                                
                            }
                            Spacer()
                            HStack {
                                TypeView(title: "PC \n평균 클릭 수", content: "\(pcAvgClick)").multilineTextAlignment(.center)
                                Spacer()
                                TypeView(title: "모바일 \n평균 클릭 수", content: "\(mobileAvgClick)").multilineTextAlignment(.center)
                                Spacer()
                                TypeView(title: "경쟁정도", content: "\(compIdx)")
                                
                            }
                            
                            //설명 뷰
                            ExplanView().padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        }
                        
                        //연관검색어 뷰
                        VStack() {
                            Spacer()
                            HStack {
                                TitleTextView(title: "연관키워드")
                                TitleTextView(title: "\(naverAdApiviewModel.keywordList.keywordList.count)개").foregroundColor(.gray)
                            }
                            ScrollView(.horizontal) {
                                LazyHStack {
                                    ForEach(0 ..< naverAdApiviewModel.keywordList.keywordList.count, id: \.self) { index in
                                        if naverAdApiviewModel.keywordList.keywordList.count > 1 {
                                            
                                            Text("\(naverAdApiviewModel.keywordList.keywordList[index].relKeyword)")
                                                .font(Font.system(size: 15))
                                                .padding()
                                                .background(Color(.secondarySystemBackground))
                                            
                                        }
                                        else {
                                            EmptyView()
                                        }
                                    }
                                }
                            }
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                        BannerAdView().frame(height: 70).padding()
                    }
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
}

struct TypeView: View {
    var title: String
    var content: String
    
    var body: some View {
        VStack{
            Spacer()
            TitleTextView(title: title)
            Spacer()
            ContentTextView(content: content)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
    }
}
struct TitleTextView: View {
    var title: String
    var body: some View {
        Text(title).fontWeight(Font.Weight.semibold).minimumScaleFactor(0.5)
    }
}

struct ContentTextView: View {
    var content: String
    var body: some View {
        Text(content)
    }
}

struct ExplanView: View {
    var body: some View {
        VStack(alignment: .leading) {
            TitleTextView(title: "PC/모바일 검색 수 - 최근 한 달간 네이버를 이용한 사용자가 PC 및 모바일 에서 해당 키워드를 검색한 횟수\n블로그/카페 글 수 - 네이버 총 검색 결과 개수\nPC/모바일 평균 클릭 수 - 최근 한 달 간 사용자가 해당 키워드를 검색했을 때, 통합검색 영역에 노출된 광고가 받은 평균 클릭수\n경쟁 정도 - 최근 한달간 해당 키워드에 대한 경쟁정도를 PC통합검색영역 기준으로 높음/중간/낮음으로 구분한 지표").foregroundColor(.gray).minimumScaleFactor(0.5)
        }
    }
}

