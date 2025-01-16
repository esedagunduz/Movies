//
//  MainViewModel.swift
//  movietrending
//
//  Created by Ebrar Gunduz on 23.07.2024.
//
import SnapKit
import Foundation
class MainViewModel{
    var isLoading :Observable<Bool> = Observable(false)
    var cellDataSouce:Observable<[MovieTableCellViewModel]> = Observable(nil)
    var isLoadingData: Observable<Bool> = Observable(false)
    var dataSource:TrendingMovieModel?
    
    
    func numberOfSections() ->Int{
        1
        
    }
    func numberOfRows(in section:Int) ->Int{
        self.dataSource?.results.count ?? 0
        
    }
    func getData(){
        if isLoading.value ?? true{
            return
        }
        isLoading.value = true
        APICaller.getTrendingMovies{[weak self]
            result in
            self?.isLoading.value=false
            switch result{
                
            case.success(let data):
                print("Top Trending Count\(data.results.count)")
                self?.dataSource = data
                self?.mapCellData()
            case.failure(let error):
                      print("error")
            }
        }
    }
 
    
    func mapCellData(){
        self.cellDataSouce.value = self.dataSource?.results.compactMap({MovieTableCellViewModel(movie: $0)})
    }
    func getMovieTitle(_ movie: Movie) -> String{
        return movie.title ?? movie.name ??  ""
    }
    func retriveMovie(withId id: Int) -> Movie? {
          guard let movie = dataSource?.results.first(where: {$0.id == id}) else {
              return nil
          }
          
          return movie
      }
    
}
