import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SearchWalletComponent } from './search-wallet.component';

describe('SearchWalletComponent', () => {
  let component: SearchWalletComponent;
  let fixture: ComponentFixture<SearchWalletComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [SearchWalletComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(SearchWalletComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
